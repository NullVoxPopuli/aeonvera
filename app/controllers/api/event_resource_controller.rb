class Api::EventResourceController < Api::ResourceController

  def index
    model = operation_class.new(current_user, params, index_params).run
    render json: model, include: params[:include]
  end

  private

  def index_params
    params.require(:event_id)
  end

  def create_params_with(attributes, host: true)
    # if host, require different part of the params
    event_relationship = params
      .require(:data).require(:relationships)
      .require(:event).require(:data).permit(:id)

    attributes.merge(event_id: event_relationship[:id])
  end
end
