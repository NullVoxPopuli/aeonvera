class Api::OrderLineItemsController < APIController

  # include EventLoader
  #
  # before_action :find_event_id
  # before_action :sets_event

  def index
    render json: @order.line_items
  end

  def create
    @order_line_item = OrderLineItem.new(order_line_item_params)
    # TODO find a way to do this better. :-\
    # maybe don't nest the polymorphic?
    # or find a way to nest in ember?
    @order_line_item.line_item_type = "LineItem::Shirt" if order_line_item_params[:line_item_type] == "Shirt"
    @order_line_item.save

    render json: @order_line_item
    # respond_with @order_line_item
  end

  private

  def order_line_item_params
    # TODO: verify that the order is on the event that the user has access to
    params[:order_line_item].permit(
      :line_item_id, :line_item_type, :order_id, :price, :quantity
    )
  end

  # def find_event_id
  #   params[:event_id] = params[]
  # end

end
