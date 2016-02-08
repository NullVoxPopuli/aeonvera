class Api::LessonsController < Api::EventResourceController
  private

  def index_params
    params[:filter] ? params : params.require(:organization_id)
  end

  def update_line_item_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:name, :price)
    end

  def create_line_item_params
    create_params_with(update_line_item_params, host: true)
  end
end
