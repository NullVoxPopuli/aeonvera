class Api::CompetitionsController < APIController
  include SkinnyControllers::Diet
  def index
    # operation = Operations::Competition::Read.new(current_user, params)
    # render json: operation.run
    render json: model
  end

  def show
    # operation = Operations::Competition::Read.new(current_user, params)
    # render json: operation.run
    render json: model
  end

end
