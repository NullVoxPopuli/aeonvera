class Api::EventResourceController < Api::ResourceController

  def index
    model = operation_class.new(current_user, params, index_params).run
    render json: model, include: params[:include]
  end

  private

  def index_params
    params.require(:event_id)
  end
end
