# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  # overrides devise's respond_with
  def respond_with(obj, *_args)
    if obj.respond_to?(:errors) && obj.errors.present?
      render json: obj, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
    else
      render json: obj, serializer: Api::UserSerializer
    end
  end

  def destroy
    if resource.upcoming_events.count > 0
      flash[:notice] = 'You cannot delete your account when you are about to attend an event. You will first have to cancel all your attendances'
      redirect_to root_path
    else
      resource.destroy

      if resource.deleted?
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        set_flash_message :notice, :destroyed if is_flashing_format?
      else
        flash[:notice] = if resource.errors.full_messages.present?
                           resource.errors.full_messages.first
                         else
                           'There was an error deleting your account'
                         end
      end
      yield resource if block_given?
      respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end
