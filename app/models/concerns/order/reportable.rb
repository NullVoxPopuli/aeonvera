module Order::Reportable
  extend ActiveSupport::Concern

  # ideally, this is ran upon successful payment
  def set_net_amount_received_and_fees

    if self.payment_method == Payable::Methods::STRIPE
      set_net_amount_received_and_fees_from_stripe
    end
  end

end
