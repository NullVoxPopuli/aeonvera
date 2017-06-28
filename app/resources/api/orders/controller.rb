# frozen_string_literal: true
module Api
  # Note that unless authenticated, all requests
  # to this controller must include a
  # payment_token param
  class OrdersController < Api::ResourceController
    before_action :check_authentication, only: [
      :index, :refund_payment, :refresh_stripe, :mark_paid,
      :destroy
    ]

    # if payment_token is at all passed as a top-level param,
    # assume the user isn't logged in, and authenticate
    # order actions based on the payment_token
    before_action :handle_via_token?, except: [:refresh_stripe, :refund_payment, :mark_paid, :create]

    def check_authentication
      return true if params[:payment_token]

      must_be_logged_in
    end

    def index
      if params[:id]
        @model = OrderOperations::Read.new(current_user, params).run

        render json: @model, include: params[:include]
        return
      end

      super
    end

    def show
      render_model('order_line_items.line_item')
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

    def mark_paid
      # attendance has to be included here for the checkin-screen.
      # because owning money is stored on the attendance. :-\
      render_model('attendance')
    end

    private

    # Note te self, if a before_action helper
    # renders are redirects, the callback chain is halted
    def handle_via_token?
      return unless params[:payment_token].present?

      @model = Order.find_by_payment_token(params[:payment_token])

      if @model
        render_model('order_line_items.line_item')
      else
        not_found
      end
    end

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
