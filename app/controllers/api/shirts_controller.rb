class Api::ShirtsController < Api::EventResourceController
  self.model_class = LineItem::Shirt
  self.model_key = 'shirt'

  private

  def update_shirt_params
    whitelistable_params do |whitelister|
      whitelister.permit(
        :name, :price, :description,
        :expires_at, :starts_at, :ends_at, :becomes_available_at,
        :duration_amount, :duration_unit,
        :logo,
        :logo_file_name, :logo_file_size,
        :logo_updated_at, :logo_content_type,
        :registration_opens_at, :registration_closes_at
      )
    end
  end

  def create_shirt_params
    whitelister_params(polymorphic: [:host]) do |whitelister|
      whitelister.permit(
        :host_id, :host_type,
        :name, :price, :description,
        :expires_at, :starts_at, :ends_at, :becomes_available_at,
        :duration_amount, :duration_unit,
        :logo,
        :logo_file_name, :logo_file_size,
        :logo_updated_at, :logo_content_type,
        :registration_opens_at, :registration_closes_at
      )
    end
  end
end
