# this logic also exists on the front end :-(
module PriceCalculator
  module_function


  CARD_FEE_PERCENTAGE = 0.029
  CONSTANT_CARD_FEE = 0.3

  APP_FEE_PERCENTAGE = 0.0075


  # estimated - actual fee is calculated on the total
  # charging service fees hurts morale. Its best to
  # absort the fee.
  def calculate_for_sub_total(value, absorb_fees: false)
    buyer_pays_value = 0
    you_get_value = 0
    service_fee_value = 0
    card_fee_value = 0

    if value > 0
      if absorb_fees
        service_fee_value = value * 0.0075
        card_fee_value = value * 0.029 + 0.3
        buyer_pays_value = value
        you_get_value = buyer_pays_value - service_fee_value - card_fee_value
      else
        you_get_value = value
        buyer_pays_value = (you_get_value + 0.3) / (1 - (0.029 + 0.0075))

        service_fee_value = buyer_pays_value * 0.0075
        card_fee_value = buyer_pays_value * 0.029 + 0.3
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
end
