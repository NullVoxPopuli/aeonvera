class Api::OrderLineItemsController < APIController

  def index
    render json: @order.line_items
  end

  def create

  end

  private

  def order_line_item_params
    params[:order_line_item].permit(

    )
  end

end
