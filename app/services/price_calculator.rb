# frozen_string_literal: true
module PriceCalculator
  module_function

  CARD_FEE_PERCENTAGE = 0.029
  CONSTANT_CARD_FEE = 0.3

  APP_FEE_PERCENTAGE = 0.0075

  # estimated - actual fee is calculated on the total
  # charging service fees hurts morale. Its best to
  # absort the fee.
  #
  # this logic also exists on the front end :-(
  def calculate_for_sub_total(
    value,
    absorb_fees: false,
    skip_application_fee: false,
    constant_card_fee: CONSTANT_CARD_FEE,
    allow_negative: false
  )

    buyer_pays_value = 0
    you_get_value = 0
    service_fee_value = 0
    card_fee_value = 0

    app_fee = skip_application_fee ? 0 : APP_FEE_PERCENTAGE

    if allow_negative || value > 0
      if absorb_fees
        service_fee_value = value * app_fee
        card_fee_value = value * CARD_FEE_PERCENTAGE + constant_card_fee
        buyer_pays_value = value
        you_get_value = buyer_pays_value - service_fee_value - card_fee_value
      else
        you_get_value = value
        buyer_pays_value = (you_get_value + constant_card_fee) / (1 - (CARD_FEE_PERCENTAGE + app_fee))

        service_fee_value = buyer_pays_value * app_fee
        card_fee_value = buyer_pays_value * CARD_FEE_PERCENTAGE + constant_card_fee
      end
    end

    {
      fees_paid_by_event: absorb_fees,
      received_by_event: you_get_value.round(2),
      sub_total: value.round(2),
      card_fee: card_fee_value.round(2),
      application_fee: service_fee_value.round(2),
      total_fee: (card_fee_value + service_fee_value).round(2),
      total: buyer_pays_value.round(2),
      buyer_pays: buyer_pays_value.round(2)
    }
  end

  # returns a list of things that are needed to calculate the
  # new new received after a refund
  def calculate_refund(refund_amount)
    PriceCalculator.calculate_for_sub_total(
      refund_amount,
      absorb_fees: true,
      skip_application_fee: true,
      constant_card_fee: 0
    )
  end
end
