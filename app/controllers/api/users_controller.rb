class Api::UsersController < Api::ResourceController
  before_filter :must_be_logged_in, except: :create

  def show
    # this should never return any other user
    # there is no multi-user management.
    render json: current_user, include: params[:include]
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
