require 'spec_helper'

describe StripeCharge do

  context 'charge_card!' do

  end

  context 'to_cents' do
    it 'converts dollars to cents' do
      expect(StripeCharge.to_cents(10)).to eq 1000
      expect(StripeCharge.to_cents(9.87)).to eq 987
    end
  end

  context 'statement_description' do
    it 'limits a string to 15 characters' do
      text = "This is some long text about something"

      result = StripeCharge.statement_description(text)
      actual = result.length

      expect(actual).to eq 15
    end

    it 'does not limit short strings' do
      text = 'short string'

      result = StripeCharge.statement_description(text)
      actual = result.length

      expect(actual).to be < 15
    end
  end

end
