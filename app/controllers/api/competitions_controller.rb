class Api::CompetitionsController < APIController

  def index
    operation = Operations::Competition::Read.new(current_user, params)
    render json: operation.run
  end

  def show
    operation = Operations::Competition::Read.new(current_user, params)
    render json: operation.run
  end

end
