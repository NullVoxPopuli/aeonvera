class Api::UserController < APIController

  def show
    render json: current_user
  end

  def update

  end

  def destroy

  end

end
