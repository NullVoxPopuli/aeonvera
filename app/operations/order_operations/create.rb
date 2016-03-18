module OrderOperations

  class Create < SkinnyControllers::Operation::Base
    include StripeCharge

    def run
      # when is creating an order ever not allowed?
      # - I'm sure the organizers would always be happy to take money
      create!

      if model.errors.blank?
        AttendanceMailer.payment_received_email(order: model).deliver_now
      end

      model
    end

    def create!
      order_params = params[:order]
      # for some reason this is a hash trying to be an array (with indicies)
      items = params[:orderLineItems].values
      host_id, host_type = order_params.values_at(:hostId, :hostType)
      user_email = order_params[:userEmail]
      checkout_token = order_params[:checkoutToken]

      # get the event / organization that this order ties to
      host = host_from(host_id, host_type)
      absorb_fees = !host.make_attendees_pay_fees?

      # get the stripe credentials
      integration = host.integrations[Integration::STRIPE]
      access_token = integration.config['access_token']

      build_order(host, items)

      if @model.sub_total > 0
        # hopefully this never happens... but we want specific errors
        # just in case
        check_required_information(checkout_token, integration, access_token)
        return if @model.errors.present?

        # charge the card.
        # this will add errors to the model if something
        # goes wrong with the charge process
        # NOTE: if this succeeds, the order is saved
        charge_card!(
          checkout_token,
          user_email,
          absorb_fees: absorb_fees,
          secret_key: access_token,
          order: @model
        )

      else
        @model.paid = true
        @model.payment_method = Payable::Methods::Cash

        return if @model.errors.present?
        save_order
      end
    end

    def save_order
      ActiveRecord::Base.transaction do
        @model.save
        @model.line_items.map(&:save)
      end
    end

    def build_order(host, items)
      # build out the order
      @model = Order.new(
        host: host,
        # is a user required?
        # what if the current user isn't the one paying?
        user: current_user
      )

      # build out the order line items
      items.each do |item_data|
        item = OrderLineItem.new(
          line_item_id: item_data[:lineItemId],
          line_item_type: item_data[:lineItemType],
          price: item_data[:price],
          quantity: item_data[:quantity],
          order: @model
        )

        if item.valid?
          @model.line_items << item
        else
          @model.errors.add(:base, item.errors.full_messages.to_s)
        end
      end
    end

    def host_from(id, type)
      if type.downcase.include?('organization')
        Organization.find(id)
      else
        Event.find(id)
      end
    end

    def check_required_information(checkout_token, integration, access_token)
      unless checkout_token.present?
        @model.errors.add(:base, 'No Stripe Checkout Information Found')
      end

      unless integration.present?
        @model.errors.add(:base, 'No Stripe Integration Present')
      end

      unless access_token.present?
        @model.errors.add(:base, 'No Stripe Access Token Present')
      end
    end
  end

end
