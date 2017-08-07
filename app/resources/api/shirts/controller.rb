# frozen_string_literal: true

module Api
  class ShirtsController < Api::EventResourceController
    self.serializer = ShirtSerializableResource

    # self.model_class = LineItem::Shirt
    # self.model_key = 'shirt'

    private

    # NOTE `sizes` in an out-of-convention structure that is handled in
    # the operation
    def update_shirt_params
      whitelistable_params do |whitelister|
        result = whitelister.permit(
          :name, :price, :description,
          :expires_at, :starts_at, :ends_at, :becomes_available_at,
          :duration_amount, :duration_unit,
          :initial_stock,
          :picture,
          :picture_file_name, :picture_file_size,
          :picture_updated_at, :picture_content_type,
          :registration_opens_at, :registration_closes_at
        )

        result.merge('sizes' => whitelister['sizes'])
      end
    end

    def create_shirt_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        result = whitelister.permit(
          :host_id, :host_type,
          :name, :price, :description,
          :expires_at, :starts_at, :ends_at, :becomes_available_at,
          :duration_amount, :duration_unit,
          :initial_stock,
          :picture,
          :picture_file_name, :picture_file_size,
          :picture_updated_at, :picture_content_type,
          :registration_opens_at, :registration_closes_at
        )

        result.merge('sizes' => whitelister['sizes'])
      end
    end
  end
end
