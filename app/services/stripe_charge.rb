module StripeCharge

  module_function

  
  # requires that a host (event, org) exists
  # also integration
  # also order
  #
  #
  #
  # @param [String] secret_key the access token here is what determines
  #                 what account the charge gets sent to
  #
  def charge_card!(token, email, absorb_fees: false, secret_key: nil, order: nil)
    host = order.host
    description = host.name
    beta = host.beta?

    # used to remove fees for at the door
    # Stripe == fees (paid by customer)
    # Credit == no fees (paid by event)
    # This is to not confuse attendees (why is there this hidden fee?).
    #
    # at least for now, this is handled here until the checkin screen
    # can be done in ember, where changing payment method on screen makes
    # more sense.
    order.payment_method = params[:payment_method] if params[:payment_method]

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
        chargeData[:application_fee] = to_cents(order.fee)
      end

      charge = Stripe::Charge.create(chargeData, secret_key)
      order.handle_stripe_charge(charge)
    rescue Stripe::CardError => e
      # The card has been declined
      order.errors.add(:base, e.message)
    end

    order
  end


  # @param [Integer] from amount to be charged
  # @param [Integer] multiplier what to multiply the amount by
  # @param [Symbol] output conversion method
  def to_cents(from, multiplier: 100, output: :to_i)
    (from * multiplier).send(output)
  end

  def statement_description(string)
    string.length > 15 ? string[0..14] : string
  end


end
