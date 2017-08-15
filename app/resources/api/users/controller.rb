# frozen_string_literal: true

module Api
  class UsersController < ResourceController
    self.serializer = UserSerializableResource

    before_action :must_be_logged_in, except: :create

    def show
      # this should never return any other user
      # there is no multi-user management.
      render_jsonapi(model: current_user)
    end

    def destroy
      # ensure the password is correct, otherwise error
      if current_user.valid_password?(params[:password])
        super
        AccountMailer.account_cancelled(model).deliver_now
      else
        current_user.errors.add(:password, 'must be present')
        render json: current_user,
               status: 422,
               serializer: ActiveModel::Serializer::ErrorSerializer
      end
    end

    private

    def update_user_params
      whitelisted_params_helper(
        :first_name, :last_name,
        :email,
        :password,
        :password_confirmation,
        :time_zone,
        :current_password
      )
    end

    def user_params
      whitelisted_params_helper(
        :first_name, :last_name,
        :email,
        :password,
        :password_confirmation,
        :time_zone
      )
    end

    def whitelisted_params_helper(*list)
      allowed_params = whitelistable_params do |whitelister|
        whitelister.permit(list)
      end
      # don't worry about null / '' fields
      # all fields on a user are required,
      # yet the password fields are optional
      allowed_params.select { |_, v| v.present? }
    end
  end
end
