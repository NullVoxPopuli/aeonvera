class Api::LineItemsController < Api::EventResourceController
  private

  def update_line_item_params
    whitelistable_params(polymorphic: [:host]) do |whitelister|
      whitelister.permit(
        :name, :price, :description,
        :expires_at, :starts_at, :ends_at, :becomes_available_at,
        :duration_amount, :duration_unit,
        :registration_opens_at, :registration_closes_at
      )
    end
  end

  def create_line_item_params
    whitelistable_params(polymorphic: [:host]) do |whitelister|
      whitelister.permit(
        :host_id, :host_type,
        :name, :price, :description,
        :expires_at, :starts_at, :ends_at, :becomes_available_at,
        :duration_amount, :duration_unit,
        :registration_opens_at, :registration_closes_at
      )
    end
  end
end
