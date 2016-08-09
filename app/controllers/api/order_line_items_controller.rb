module Api
  class OrderLineItemsController < Api::ResourceController
    def create
      render_model('line_item', success_status: 201)
    end

    def update
      render_model('line_item')
    end

    private

    def create_order_line_item_params
      whitelistable_params(polymorphic: [:line_item]) do |whitelister|
        whitelister.permit(
          :line_item_id, :line_item_type, :order_id,
          :price, :quantity,
          :partner_name, :dance_orientation, :size
        )
      end
    end

    def update_order_line_item_params
      whitelistable_params do |whitelister|
        whitelister.permit(
          :price, :quantity,
          :partner_name, :dance_orientation, :size
        )
      end
    end
  end
end
