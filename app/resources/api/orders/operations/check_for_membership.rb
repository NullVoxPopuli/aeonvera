# frozen_string_literal: true

module Api
  module OrderOperations
    # This should only be used for organizations
    class CheckForMembership
      def initialize(order_id)
        @order = Order.find(order_id)
      end

      def call
        return unless @order.paid? && @order.user.present?
        return unless has_membership_option?

        create_memberships
      end

      private

      def create_memberships
        membership_options.each do |option|
          create_renewal_for_membership_option(option)
        end
      end

      def create_renewal_for_membership_option(membership_option)
        renewal = MembershipRenewal.new(
          user: @order.user,
          membership_option: membership_option,
          start_date: Time.current
        )

        renewal.save!
      end

      def membership_options
        @membership_options ||= begin
          @order.order_line_items.select do |oli|
            oli.line_item_type.include? MembershipOption.name
          end.map(&:line_item)
        end
      end

      def has_membership_option?
        membership_options.present?
      end
    end
  end
end
