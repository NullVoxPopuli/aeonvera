# frozen_string_literal: true
module HasPaymentProcessor
  extend ActiveSupport::Concern

  # return a list of API configurations for payment methods
  # PayPal has both Rest and SOAP.
  # - Currently, REST doesn't support specifying who recieves the money
  # - SOAP is icky
  #
  # Eventually add support for google checkout, amazon, etc
  def payment_methods
    [
      integrations[Integration::STRIPE]
    ]
  end

  # @param [String] kind optional
  # @return [Boolean] true if any processors exist
  # @return [Boolean] true if the specified processor exists
  def has_payment_processor?(kind = '')
    if kind.present?
      integrations[kind].present?
    else
      integrations[Integration::STRIPE].present?
    end
  end
end
