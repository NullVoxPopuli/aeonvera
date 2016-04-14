class Api::LineItemsController < Api::EventResourceController
  private

  def update_line_item_params
    ActiveModelSerializers::Deserialization
      .jsonapi_parse(params, only: [
        :name, :price, :description,
        :expires_at, :starts_at, :ends_at, :becomes_available_at,
        :duration_amount, :duration_unit,
        :registration_opens_at, :registration_closes_at
      ])
  end

  def create_line_item_params
    create_params_with(update_line_item_params)
  end
end
