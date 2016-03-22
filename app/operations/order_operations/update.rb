module OrderOperations
  class Update < SkinnyControllers::Operation::Base

    def run
      if allowed?
        update

        # if model.errors.blank?
        #   AttendanceMailer.payment_received_email(order: model).deliver_now
        # end

      else
        # TODO: how to send error?
        raise 'not authorized'
      end

      model
    end

    def update
      order = model
      order_params = params[:order]
      stripe_params = params[:stripe]

      if order_params[:payment_method] != Payable::Methods::STRIPE
        model.check_number = order_params[:check_number]

        model.paid = true
        model.paid_amount = order_params[:paid_amount]
        model.net_amount_received = order.paid_amount
        model.total_fee_amount = 0
        model.save if order.errors.full_messages.empty?
      else
        # if this succeeds, the order will be saved
        update_stripe
      end
    end

    def update_stripe
      # get the stripe credentials
      integration = model.host.integrations[Integration::STRIPE]
      access_token = integration.config['access_token']
      checkout_token = params_for_action[:checkoutToken]
      absorb_fees = !model.host.make_attendees_pay_fees?

      # hopefully this never happens... but we want specific errors
      # just in case
      check_required_information(checkout_token, integration, access_token)
      return if model.errors.present?

      # charge the card.
      # this will add errors to the model if something
      # goes wrong with the charge process
      # NOTE: if this succeeds, the order is saved
      charge_card!(
        checkout_token,
        user_email,
        absorb_fees: absorb_fees,
        secret_key: access_token,
        order: model
      )
    end

    def check_required_information(checkout_token, integration, access_token)
      unless checkout_token.present?
        model.errors.add(:base, 'No Stripe Checkout Information Found')
      end

      unless integration.present?
        model.errors.add(:base, 'No Stripe Integration Present')
      end

      unless access_token.present?
        model.errors.add(:base, 'No Stripe Access Token Present')
      end
    end
  end
end
