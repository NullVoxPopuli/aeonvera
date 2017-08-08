# frozen_string_literal: true

# this class overrides some things from devise in order to
# make it JSON API compliant
#
# see: https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb
module Api
  module Users
    module DeviseOverrides
      class AccountRegistrationsController < Devise::RegistrationsController
        include Controllers::ModelRendering

        self.serializer = UserSerializableResource
        # skip_before_filter :authenticate_user!

        protected

        def respond_with(obj, *_args)
          render_jsonapi(model: obj)
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
            :time_zone
          )
        end
      end
    end
  end
end
