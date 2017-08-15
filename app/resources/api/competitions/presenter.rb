# frozen_string_literal: true

module Api
  class CompetitionPresenter < ApplicationPresenter
    delegate :id, :name, :initial_price, :at_the_door_price, :current_price,
             :kind, :kind_name, :requires_partner, :requires_orientation,
             :description, :nonregisterable, :event, to: :object

    def order_line_items
      @olis ||= @object.order_line_items
    end

    def order_line_items_with_registrations
      @order_line_items ||= begin
        attending = Registration.arel_table[:attending]

        order_line_items.joins(order: :registration)
                        .where(attending.eq(true))
      end
    end

    def registrations
      @registrations ||= begin
        order_line_items_with_registrations
          .map { |order_line_item| order_line_item.order.registration }
          .uniq(&:id)
      end
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
