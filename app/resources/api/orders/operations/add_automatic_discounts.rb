# frozen_string_literal: true

module Api
  module OrderOperations
    # This should be called when an OrderLineItem is:
    # - created
    # - removed
    # - quantity is changed.
    class AddAutomaticDiscounts
      include ::AssertParameters

      # rtype([{ user: User, host: [Event, Organization] }, {}] => Any)
      # rtype([Order] => Any)
      def initialize(order)
        @order = order

        # Only the host is required.
        # but the lack of a user will prevent
        # #run from doing anything
        assert!(order, :host)
      end

      def run
        # A user/buyer MUST be required in order to receive an automatic discount
        # (those who are not logged in don't get a user, and therefor
        #  don't get automatic discounts)
        return unless @order.user

        return unless may_be_eligable_for_automatic_discount?

        # Currently, only organization discounts are supported.
        # TOOD: need to add auto-discount for if a person is a member of an org
        #       that sponsors an event.
        return unless @order.belongs_to_organization?

        # finally, figure out what discounts to add.
        if applicable_membership_discounts.present?
          add_to_order(applicable_membership_discounts)
        else
          clear_discounts
        end
      end

      private

      def clear_discounts
        host.membership_discounts.each do |discount|
          @order.order_line_item_for_item(discount)&.destroy
        end
      end

      # Add if doesn't already exist.
      # make quantity match number of applicable line items
      def add_to_order(discounts)
        discounts = Array[*discounts]

        ApplicationRecord.transaction do
          discounts.each do |discount|
            # TODO: what do we do with percents?
            next if discount.percent_discount?

            order_line_item = @order.order_line_item_for_item(discount)
            quantity = order_line_items
                       .select { |oli| oli.line_item_type == discount.affects }
                       .map(&:quantity)
                       .inject(:+)

            # TODO: also handle discount#restrained_to?(specific item)
            if quantity == 0
              order_line_item.destroy
              next
            end

            if order_line_item
              order_line_item.update(quantity: quantity)
              next
            end

            # create
            oli = @order.order_line_items.new(
              line_item: discount,
              line_item_type: discount.class.name,
              price: 0 - discount.value,
              quantity: quantity
            )

            oli.save

            oli
          end
        end
      end

      def order_line_items
        @order_line_items ||= @order.order_line_items
      end

      def applicable_membership_discounts
        @applicable_membership_discounts ||= begin
          types = order_line_items.map(&:line_item_type)

          affects = MembershipDiscount.arel_table[:affects]

          organization.membership_discounts
                      .where(affects.in(types))
          # TODO: for when the upgrade to rails 5 is finished
          # .or(organization.membership_discounts
          #   .where(affects: nil))
        end
      end

      def organization
        @organization ||= begin
          if is_event?
            host.sponsoring_organizations.first
          else
            host
          end
        end
      end

      def is_event?
        host.is_a?(Event)
      end

      def host
        @host ||= @order.host
      end

      def may_be_eligable_for_automatic_discount?
        return false unless organization
        return false unless organization.membership_discounts.present?
        return true if @order.user.is_member_of?(organization)

        current_order_contains_membership_purchase?
      end

      def current_order_contains_membership_purchase?
        options = organization.membership_options

        options
          .map { |option| @order.order_line_item_for_item(option) }
          .map(&:present?)
          .any?
      end
    end
  end
end
