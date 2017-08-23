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
        #
        # def create
        #   build_resource(sign_up_params)
        #
        #   resource_saved = resource.save
        #   yield resource if block_given?
        #   if resource_saved
        #     if resource.active_for_authentication?
        #       set_flash_message :notice, :signed_up if is_flashing_format?
        #       sign_up(resource_name, resource)
        #       respond_with resource, location: after_sign_up_path_for(resource)
        #     else
        #       set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        #       expire_data_after_sign_in!
        #       respond_with resource, location: after_inactive_sign_up_path_for(resource)
        #     end
        #   else
        #     clean_up_passwords resource
        #     @validatable = devise_mapping.validatable?
        #     if @validatable
        #       @minimum_password_length = resource_class.password_length.min
        #     end
        #     respond_with resource
        #   end
        # end

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
