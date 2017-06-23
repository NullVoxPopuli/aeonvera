# frozen_string_literal: true
module Api
  class OrdersController < Api::ResourceController
    before_filter :must_be_logged_in, only: [
      :index, :refund_payment, :refresh_stripe, :mark_paid,
      :destroy
    ]

    def index
      render_models(params[:include])
    end

    def create
      render_model('order_line_items.line_item')
    end

    def update
      render_model('order_line_items.line_item,attendance')
    end

    def refresh_stripe
      render_model
    end

    def refund_payment
      render_model
    end

    def find_by_token
      render_model('order_line_items.line_item')
    end

    def mark_paid
      # attendance has to be included here for the checkin-screen.
      # because owning money is stored on the attendance. :-\
      render_model('attendance')
    end

    private

    def refund_payment_order_params
      params.permit(:refund_type, :partial_refund_amount)
    end

    def mark_paid_order_params
      params.permit(
        :id,
        :amount, :payment_method, :check_number, :notes
      )
    end

    def find_by_token_order_params
      params.require(:order).permit(
        :host_id, :host_type, :payment_token,
        :user_id
      )
    end

    def create_order_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :attendance_id, :host_id, :host_type,
          :pricing_tier_id,
          :payment_method,
          :user_email, :user_name,
          :payment_token
        )
      end
    end

    def update_order_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :attendance_id, :host_id, :host_type, :payment_method,
          :user_email, :user_name,

          # specifically for payment
          # the presence of these keys determines if we are paying or
          # just updating the order / order-line-item data
          :payment_method, :checkout_token, :checkout_email, :check_number,

          # This is for when a user isn't logged in.
          :payment_token
        )
      end
    end

    # TODO: is this used anywhere?
    def order_where_params
      keys = (Order.column_names & params.keys)
      params.slice(*keys).symbolize_keys
    end
  end
end
