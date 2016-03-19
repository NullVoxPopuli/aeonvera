class Api::UsersController < APIController
  include SkinnyControllers::Diet
  before_filter :must_be_logged_in, except: :create

  def show
    # this should never return any other user
    # there is no multi-user management.
    render json: current_user, include: params[:include]
  end
end
