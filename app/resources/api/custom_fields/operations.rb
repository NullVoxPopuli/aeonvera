# frozen_string_literal: true
module Api
  module CustomFieldOperations
    class Create < SkinnyControllers::Operation::Base
      def run
        custom_field = CustomField.new(model_params)
        custom_field.user = current_user

        if allowed_for?(custom_field)
          custom_field.save
        else
          custom_field.errors.add(:base, 'not authorized')
        end

        custom_field
      end
    end
  end
end
