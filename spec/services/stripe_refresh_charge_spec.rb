require 'spec_helper'

describe StripeRefreshCharge do
  describe '#calculate_totals_after_refund' do

    it 'correctly derives the new totals' do
      order = Order.new(
        total_fee_amount: 4.29,
        paid_amount: 109.29,
        net_amount_received: 105
      )

      result = StripeRefreshCharge.calculate_totals_after_refund(order, 20.75)

      expect(result[:paid_amount]).to         be_within(1e-12).of 88.54
      expect(result[:net_amount_received]).to be_within(1e-12).of 84.85
      expect(result[:total_fee_amount]).to    be_within(1e-12).of 3.69
    end

  end
end
