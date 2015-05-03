class PaymentProcessorInterface
  include AbstractInterface


  needs_implementation :return_url, :cancul_url,
    :payment_recieved_url,
    :initialize, :payment_details,
    :api, :pay!, :refund!

  HOST = APPLICATION_CONFIG["domain"][Rails.env]



  def return_url

  end

  def cancel_url

  end

  def payment_recieved_url

  end

  def initialize(order, payment)

  end

  def payment_details

  end

  def pay!

  end

  def refund!

  end

  private

  def api

  end
end
