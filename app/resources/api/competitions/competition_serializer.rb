# frozen_string_literal: true
module Api
  class CompetitionSerializer < ActiveModel::Serializer
    include PublicAttributes::CompetitionAttributes
    attributes :number_of_follows, :number_of_leads, :number_of_registrants

    # this mess is for getting the minimum data for a competition overview. gross.
    class OrderLineItemSerializer < Api::OrderLineItemSerializer
      # override the top-level order-serializer, because it has
      # a lot of relationships that we don't care about right now
      class OrderSerializer < ActiveModel::Serializer
        attributes :id, :user_email, :user_name, :payment_received_at, :created_at

        class RegistrationSerializer < ActiveModel::Serializer
          attributes :id
        end

        # we just want to get to the associated registration id
        belongs_to :registration, serializer: Api::CompetitionSerializer::OrderLineItemSerializer::OrderSerializer::RegistrationSerializer

        def user_email
          object.buyer_email
        end

        def user_name
          object.buyer_name
        end
      end

      class LineItemSerializer < ActiveModel::Serializer; end

      # override the superclass's serializer
      belongs_to :line_item, serializer: Api::CompetitionSerializer::OrderLineItemSerializer::LineItemSerializer
      belongs_to :order, serializer: Api::CompetitionSerializer::OrderLineItemSerializer::OrderSerializer
    end

    # registrations are not required for these, so we can't constrain
    has_many :order_line_items, serializer: Api::CompetitionSerializer::OrderLineItemSerializer
    # has_many :registrations

    def order_line_items_with_registrations
      return @order_line_items if @order_line_items

      attending = Registration.arel_table[:attending]
      @order_line_items = object
                          .order_line_items.joins(order: :registration)
                          .where(attending.eq(true))
    end

    def registrations
      return @registrations if @registrations

      @registrations = order_line_items_with_registrations
                       .map { |order_line_item| order_line_item.order.registration }
                       .uniq(&:id)

      @registrations
    end

    def number_of_registrants
      object.order_line_items.count
    end

    def number_of_leads
      order_line_items_with_registrations
        .where(dance_orientation: Registration::LEAD)
        .count
    end

    def number_of_follows
      order_line_items_with_registrations
        .where(dance_orientation: Registration::FOLLOW)
        .count
    end
  end
end
