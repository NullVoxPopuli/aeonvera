# frozen_string_literal: true

module Api
  class LineItemsController < Api::EventResourceController
    self.serializer = LineItemSerializableResource

    private

    def update_line_item_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :name, :price, :description,
          :expires_at, :starts_at, :ends_at, :becomes_available_at,
          :duration_amount, :duration_unit,
          :initial_stock,
          :picture,
          :picture_file_name, :picture_file_size,
          :picture_updated_at, :picture_content_type,
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
          :intial_stock,
          :picture,
          :picture_file_name, :picture_file_size,
          :picture_updated_at, :picture_content_type,
          :registration_opens_at, :registration_closes_at
        )
      end
    end
  end
end
