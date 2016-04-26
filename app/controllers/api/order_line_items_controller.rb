class Api::OrderLineItemsController < Api::ResourceController
  def create
    render_model('line_item')
  end

  def update
    render_model('line_item')
  end

  private

  def deserialized_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(
      params, polymorphic: [:line_item])
  end

  def create_order_line_item_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelisted = whitelister.permit(
      :line_item_id, :line_item_type, :order_id,
      :price, :quantity,
      :partner_name, :dance_orientation, :size
    )

    EmberTypeInflector.to_rails(whitelisted)
  end

  def update_order_line_item_params
    whitelister = ActionController::Parameters.new(deserialized_params)
    whitelisted = whitelister.permit(
      :price, :quantity,
      :partner_name, :dance_orientation, :size
    )

    EmberTypeInflector.to_rails(whitelisted)
  end
end
