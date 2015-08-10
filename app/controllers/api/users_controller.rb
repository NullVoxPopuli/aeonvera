class Api::UsersController < APIController

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      respond_with user
    end
  end

  private

  def user_params
    params[:user].permit(
      :first_name, :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end

end
