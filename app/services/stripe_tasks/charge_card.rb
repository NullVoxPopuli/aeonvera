module StripeTasks
  module ChargeCard

    module_function


    # requires that a host (event, org) exists
    # also integration
    # also order
    #
    #
    # @param [String] token the stripe-checkout.js token from the UI
    # @param [String] email who to send the receipt to
    # @param [Boolean] absorb_fees if the event host should eat the fees or not
    # @param [String] secret_key the access token here is what determines
    #                 what account the charge gets sent to
    #
    def charge_card!(token, email, absorb_fees: false, secret_key: nil, order: nil)
      host = order.host
      description = host.name
      beta = host.beta?

      amount = order.total(absorb_fees: absorb_fees)

      begin
        chargeData =  {
          amount: to_cents(amount),
          currency: "usd",
          source: token,
          description: email,
          statement_descriptor: statement_description(description).gsub(/'/, ''),
          receipt_email: email
        }

        if !beta
          chargeData[:application_fee] = to_cents(order.application_fee)
        end

        charge = Stripe::Charge.create(chargeData, secret_key)
        order.handle_stripe_charge(charge)
      rescue Stripe::CardError => e
        # The card has been declined
        order.errors.add(:base, e.message)
      rescue Stripe::InvalidRequestError => e
        order.errors.add(:base, e.message)
      end

      order
    end


    # @param [Integer] from amount to be charged
    # @param [Integer] multiplier what to multiply the amount by
    # @param [Symbol] output conversion method
    def to_cents(from, multiplier: 100, output: :to_i)
      (from * multiplier).round.send(output)
    end

    def statement_description(string)
      string.length > 15 ? string[0..14] : string
    end

  end
end
