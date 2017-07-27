require 'spec_helper'

describe StripeTasks::ChargeCard do

  context 'charge_card!' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    before(:each) do
      @event = event = create_event
      package = create(:package, event: event)
      integration = create_integration(owner: event)
      order = create(:order, host: event, attendance: create(:registration, event: event))
      add_to_order(order, package)

      token = stripe_helper.generate_card_token
      @charge = ->{
        StripeTasks::ChargeCard.charge_card!(
          token,
          'whatever@idk.com',
          order: order,
          secret_key: STRIPE_CONFIG['secret_key']
        )
      }

    end

    it 'succeeds' do
      order = @charge.call
      expect(order.errors).to be_empty
    end

    it 'adds an error if the card is declined' do
      StripeMock.prepare_card_error(:card_declined)

      order = @charge.call
      expect(order.errors).to_not be_empty
    end

    it 'does not apply the application fee if the event is beta' do
      @event.beta = true
      order = @charge.call

      actual = order.paid_amount
      expected = order.total(absorb_fees: true)
      expect(actual).to eq expected
    end
  end

  context 'to_cents' do
    it 'converts dollars to cents' do
      expect(StripeTasks::ChargeCard.to_cents(10)).to eq 1000
      expect(StripeTasks::ChargeCard.to_cents(9.87)).to eq 987
    end
  end

  context 'statement_description' do
    it 'limits a string to 15 characters' do
      text = "This is some long text about something"

      result = StripeTasks::ChargeCard.statement_description(text)
      actual = result.length

      expect(actual).to eq 15
    end

    it 'does not limit short strings' do
      text = 'short string'

      result = StripeTasks::ChargeCard.statement_description(text)
      actual = result.length

      expect(actual).to be < 15
    end
  end

end
