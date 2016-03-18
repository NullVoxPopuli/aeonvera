module OrderOperations

  class Create < SkinnyControllers::Operation::Base
    include StripeCharge

    def run
      # when is creating an order ever not allowed?
      # - I'm sure the organizers would always be happy to take money
      create!

      if model.errors.blank?
        AttendanceMailer.payment_received_email(order: order).deliver_now
      end

      model
    end


    def create!
      host_id, host_type = params_for_action.values_at(:host_id, :host_type)
      user_email = params_for_action[:user_email]
      checkout_token = params_for_action[:checkout_token]

      # get the event / organization that this order ties to
      host = host_from(host_id, host_type)
      absorb_fees = !host.make_attendees_pay_fees?

      # get the stripe credentials
      integration = host.integrations[Integration::STRIPE]
      access_token = integration.config['access_token']

      # build out the order
      @model = Order.new(
        host: host,
        # is a user required?
        # what if the current user isn't the one paying?
        user: current_user
      )

      # hopefully this never happens... but we want specific errors
      # just in case
      if @model.sub_total > 0
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

        # build out the order line items
        return if @model.errors.present?
        @model.save
      end
    end

    def host_from(id, type)
      if type.include?('organization')
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
