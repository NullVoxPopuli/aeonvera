# this class overrides some things from devise in order to
# make it JSON API compliant
#
# see: https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb
class Api::Users::RegistrationsController < Devise::RegistrationsController
  protected

  def respond_with(obj, *args)
    if obj.errors.present?
      render json: obj, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
    else
      render json: obj
    end
  end

  def account_update_params
    update_params = params
      .require(:data)
      .require(:attributes)
      .permit(:current_password)

    sign_up_params.merge(update_params)
  end

  def sign_up_params
    params
      .require(:data)
      .require(:attributes)
      .permit(
        :first_name, :last_name,
        :email,
        :password,
        :password_confirmation,
        :time_zone
        # don't worry about null / '' fields
        # all fields on a user are required,
        # yet the password fields are optional
      ).select{ |k, v| v.present? }
  end

end
