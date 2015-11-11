class Api::LevelsController < APIController
  include EventLoader

  def index
    # TODO: also check permissions of each  levels?
    @levels = event.levels
    render json: @levels, include: params[:include]
  end

  def show
    operation = Operations::Level::Read.new(current_user, params)
    render json: operation.run
  end
end
