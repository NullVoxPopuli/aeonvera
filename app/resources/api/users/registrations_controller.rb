# frozen_string_literal: true
# this class overrides some things from devise in order to
# make it JSON API compliant
#
# see: https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb
module Api
  module Users
    class RegistrationsController < Devise::RegistrationsController
      # skip_before_filter :authenticate_user!
      protected

      def respond_with(obj, *_args)
        if obj.errors.present?
          render json: obj, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
        else
          render jsonapi: obj, serializer: Api::UserSerializer
        end
      end

      def account_update_params
        update_params = params
                        .require(:data)
                        .require(:attributes)
                        .permit(:current_password)

        sign_up_params.merge(update_params)
      end

      def deserialized_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      end

      def sign_up_params
        whitelister = ActionController::Parameters.new(deserialized_params)
        whitelister.permit(
          :first_name, :last_name,
          :email,
          :password,
          :password_confirmation,
          :time_zone)
      end
    end
  end
end
