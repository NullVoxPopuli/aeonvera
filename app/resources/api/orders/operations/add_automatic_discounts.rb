# frozen_string_literal: true
module Api
  module OrderOperations
    # This should be called when an OrderLineItem is:
    # - created
    # - removed
    # - quantity is changed.
    class AddAutomaticDiscounts
      def initialize(order)
        @order = order
      end

      def run
        user = @order.user
        host = @order.host

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
            (order_line_item.destroy; next) if quantity == 0

            if order_line_item
              order_line_item.update(quantity: quantity)
              next
            end

            # create
            @order.order_line_items.create(
              line_item: discount,
              line_item_type: discount.class.name,
              price: 0 - discount.value,
              quantity: quantity
            )
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
        @organization ||= @order.host
      end

      def host
        @host ||= @order.host
      end

      def may_be_eligable_for_automatic_discount?
        @order.user.is_member_of?(organization) && organization&.membership_discounts.present?
      end
    end
  end
end
