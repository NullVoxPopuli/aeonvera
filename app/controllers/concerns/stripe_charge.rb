module StripeCharge

  # requires that a host (event, org) exists
  # also integration
  # also order
  def charge_card!(token = params[:stripeToken], email = params[:stripeEmail], absorb_fees: false)

    # the access token here is what determines
    # what account the charge gets sent to
    secret_key = @integration.config[:access_token]

    # used to remove fees for at the door
    # Stripe == fees (paid by customer)
    # Credit == no fees (paid by event)
    # This is to not confuse people.
    #
    # at least for now, this is handled here until the checkin screen
    # can be done in ember, where changing payment method on screen makes
    # more sense.
    @order.payment_method = params[:payment_method] if params[:payment_method]

    amount = @order.total(absorb_fees: absorb_fees)

    begin
      chargeData =  {
        amount: to_cents(amount),
        currency: "usd",
        source: token,
        description: email,
        statement_descriptor: statement_description(@host.name).gsub(/'/, ''),
        receipt_email: email
      }

      if !@host.beta? && !Rails.env.development?
        chargeData[:application_fee] = to_cents(@order.fee)
      end

      charge = Stripe::Charge.create(
        chargeData,
        # the account to charge to
        secret_key
      )

      @order.handle_stripe_charge(charge)

      return true
    rescue Stripe::CardError => e
      # The card has been declined
      @order.errors.add(:base, e.message)
      flash[:error] = e.message
    end
    return false
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
