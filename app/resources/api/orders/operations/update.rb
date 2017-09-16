# frozen_string_literal: true

module Api
  module OrderOperations
    class Update < SkinnyControllers::Operation::Base
      def run
        check_allowed!

        pay if is_paying?
        modify if is_updating?

        model
      end

      private

      def check_allowed!
        return if allowed_to_update?

        raise SkinnyControllers::DeniedByPolicy, 'unauthorized'
      end

      def authorized_via_token?
        model.payment_token == params[:payment_token]
      end

      def allowed_to_update?
        return true if allowed?
        return false unless authorized_via_token?

        temp_user = OpenStruct.new(id: params[:payment_token])

        policy_class
          .new(temp_user, model)
          .update?
      end

      def is_paying?
        params_for_action[:checkout_token].present?
      end

      def is_updating?
        !is_paying?
      end

      def pay
        Pay.call(model, current_user, params, params_for_action)
      end

      def modify
        Modify.call(model, current_user, params, params_for_action)
      end
    end
  end
end
