class Api::UsersController < Api::ResourceController
  before_filter :must_be_logged_in, except: :create

  def show
    # this should never return any other user
    # there is no multi-user management.
    render json: current_user, include: params[:include]
  end

  def create
    raise 'no'
  end


  private

  def update_user_params
    user_params.merge(
      current_password: params[:user].try(:[], :current_password)
    )
  end

  def user_params
    params[:user].permit(
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
