module Api
  module OrderOperations
    #
    # This creates an order, and its order line items.
    # This does not charge a credit card. That is what Update is for.
    #
    class Create < SkinnyControllers::Operation::Base
      include HelperOperations::Helpers

      DEFAULTS = {
        payment_method: Payable::Methods::STRIPE
      }

      def run
        build_order

        @model.save
        model
      end

      private

      def build_order
        # extract non-column-backed data before creating the Order
        user_name = params_for_action.delete(:user_name)
        user_email = params_for_action.delete(:user_email)

        # build out the order
        # this will also build out the order_line_items, thanks
        # to accepts_nested_attributes_for
        @model = Order.new(order_params)

        # a user is alwoys going to be the person paying.
        # if an attendance is passed, use the user from
        # that attendance.
        @model.user = attendance.try(:attendee)
        # TODO: allow this to be set manually
        @model.user = current_user if @model.host.is_a?(Organization)

        # the payment token is used for people who aren't logged in.
        # In order to update / pay for an order, you must either
        # be the owner, or have this token in the URL
        @model.payment_token = params_for_action[:payment_token] unless @model.user
        @model.buyer_email = user_email if user_email.present?
        @model.buyer_name = user_name if user_name.present?
      end

      def order_params
        params_for_action.merge(
          host_id: host.id,
          host_type: host.class.name,

          # set default payment method if one isn't already set.
          payment_method: payment_method,

          # mostly for record keeping / whodunnit purposes
          created_by: current_user,

          # nil or will be set
          attendance: attendance # .becomes(Attendance)
        )
      end

      def payment_method
        params_for_action[:payment_method] || DEFAULTS[:payment_method]
      end

      def attendance
        # use find_by_id to not raise exception, and return nil if not found
        @attendance ||= host.attendances.find_by_id(params_for_action[:registration_id])
      end

      def host
        @host ||= host_from_params(params_for_action)
      end
    end
  end
end
