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

    handle_competition
    handle_shirt

    render json: @order_line_item
    # respond_with @order_line_item
  end

  private

  def handle_competition
    competition_response_params = {}

    if competition_params[:partner_name].present?
      competition_response_params.merge!({
        competition_id: @order_line_item.line_item_id,
        attendance: @order_line_item.order.attendance,
        partner_name: competition_params[:partner_name]
      })
    elsif competition_params[:dance_orientation].present?
      competition_response_params.merge!({
        competition_id: @order_line_item.line_item_id,
        attendance: @order_line_item.order.attendance,
        dance_orientation: competition_params[:dance_orientation]
      })
    end

    if competition_response_params.present?
      CompetitionResponse.new(competition_response_params).save
    end

  end

  def handle_shirt
    if shirt_params[:size].present?
      AttendanceLineItem.new(
        line_item: @order_line_item.line_item,
        attendance: @order_line_item.order.attendance,
        size: shirt_params[:size],
        quantity: 1
      )
    end
  end

  def order_line_item_params
    # TODO: verify that the order is on the event that the user has access to
    params[:order_line_item].permit(
      :line_item_id, :line_item_type, :order_id, :price, :quantity
    )
  end

  def competition_params
    params[:order_line_item].permit(
      :partner_name, :dance_orientation
    )
  end

  def shirt_params
    params[:order_line_item].permit(
      :size
    )
  end

  # def find_event_id
  #   params[:event_id] = params[]
  # end

end
