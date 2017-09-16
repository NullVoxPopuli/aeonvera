# frozen_string_literal: true

module Api
  module OrderOperations
    class Modify < SkinnyControllers::Operation::Base
      WHITELISTED_PARAMS = %w[user_name user_email registration_id].freeze

      # It is assumed that this operation is already authorized.
      # Therefor, it should not be invoked directly from a controller,
      # only another operation.
      def initialize(model, current_user, params, params_for_action)
        super(current_user, params, params_for_action)

        @model = model
      end

      def run
        modify

        model
      end

      private

      def modify
        update_registration(modify_order_params.delete('registration_id'))

        # extract non-column-backed data before creating the Order
        user_name = modify_order_params.delete('user_name')
        user_email = modify_order_params.delete('user_email')

        model.update_attributes(modify_order_params)
        model.buyer_email = user_email if user_email.present?
        model.buyer_name = user_name if user_name.present?

        model.save
      end

      def modify_order_params
        @modify_order_params ||= params_for_action.select do |k, _v|
          WHITELISTED_PARAMS.include?(k)
        end
      end

      # only the event owner / collaborators can update this
      def update_registration(registration_id)
        return unless registration_id
        return unless current_user
        return unless policy_class
                      .new(current_user, model)
                      .is_collaborator?

        model.registration_id = registration_id
      end
    end
  end
end
