# frozen_string_literal: true

module Api
  # Note that unless authenticated, all requests
  # to this controller must include a
  # payment_token param
  class OrderLineItemsController < Api::ResourceController
    self.serializer = OrderLineItemSerializableResource

    def index
      render_models(params[:include])
    end

    def create
      # params[:fields] = { orders: [
      #   :id,
      #     :is_fee_absorbed,
      #     :paid_amount, :net_amount_received, :total_fee_amount,
      #     :paid, :payment_method,
      #     :host_name,
      #     :user_email, :user_name,
      #     :payment_received_at,
      #     :total_in_cents,
      #     :total, :sub_total,
      #     :stripe_refunds,
      #     :current_paid_amount,
      #     :current_total_fee_amount,
      #     :current_net_amount_received,
      #     :registration
      #   ] }
      render_jsonapi(options: {
                       include: 'order.order_line_items.line_item,line_item.restraints,order.registration',
                       status: 201
                     })
    end

    def update
      render_jsonapi(options: { include: 'line_item,order.order_line_items' })
    end

    def destroy
      render_jsonapi(options: { include: 'order.order_line_items' })
    end

    def mark_as_picked_up
      render_jsonapi
    end

    private

    def create_order_line_item_params
      whitelistable_params(polymorphic: [:line_item]) do |whitelister|
        whitelister.permit(
          :line_item_id, :line_item_type, :order_id,
          :price, :quantity,
          :partner_name, :dance_orientation, :size,
          :discount_code
        )
      end
    end

    def update_order_line_item_params
      whitelistable_params(polymorphic: [:line_item]) do |whitelister|
        whitelister.permit(
          :line_item_id, :line_item_type,
          :price, :quantity,
          :partner_name, :dance_orientation, :size
        )
      end
    end
  end
end
