class Api::LineItemsController < Api::EventResourceController
  private

  def update_line_item_params
    params
      .require(:data)
      .require(:attributes)
      .permit(:name, :price,)  end

  def create_line_item_params
    create_params_with(update_line_item_params)
  end
end
