require 'spec_helper'

describe StripePaymentHandler do

  describe '#handle_stripe_charge' do

    let(:successful_charge){
      Metadata.new({
        "id" => "ch_fake_id",
        "object" => "charge",
        "created" => 1439853046,
        "livemode" => false,
        "paid" => true,
        "status" => "succeeded",
        "amount" => 5760,
        "currency" => "usd",
        "refunded" => false,
        "source" => {
          "id" => "card_fake_id",
          "object" => "card",
          "last4" => "4242",
          "brand" => "Visa",
          "funding" => "credit",
          "exp_month" => 12,
          "exp_year" => 2020,
          "fingerprint" => "fake_fingerprent",
          "country" => "US",
          "name" => "me@domain.com",
          "address_line1" => nil,
          "address_line2" => nil,
          "address_city" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_country" => nil,
          "cvc_check" => "pass",
          "address_line1_check" => nil,
          "address_zip_check" => nil,
          "tokenization_method" => nil,
          "dynamic_last4" => nil,
          "metadata" => {},
          "customer" => nil
        },
        "captured" => true,
        "balance_transaction" => "txn_fake_id",
        "failure_message" => nil,
        "failure_code" => nil,
        "amount_refunded" => 0,
        "customer" => nil,
        "invoice" => nil,
        "description" => "me@domain.com",
        "dispute" => nil,
        "metadata" => {},
        "statement_descriptor" => "SwingIN 2015",
        "fraud_details" => {},
        "receipt_email" => "me@domain.com",
        "receipt_number" => nil,
        "shipping" => nil,
        "destination" => nil,
        "application_fee" => "fee_fake_id",
        "refunds" => {
          "object" => "list",
          "total_count" => 0,
          "has_more" => false,
          "url" => "/v1/charges/fake_charge_id/refunds",
          "data" => []
        }
      })
    }

    let(:successful_charge_transaction){
      {
        "fee" => 240,
        "net" => 5520
      }
    }

    it 'correctly assigns the fields' do
      # this test uses data from a fake stripe transaction
      # the data within that stripe charge object is what
      # contains the test values - the stubbed values don't
      # matter
      o = Order.new

      # just needs to be above 0
      allow(o).to receive(:host){ create(:event) }
      allow(o).to receive(:sub_total){ 15 }
      allow(o).to receive(:get_stripe_transaction_id){ successful_charge_transaction }

      o.handle_stripe_charge(successful_charge)

      expect(o.paid).to eq true
      expect(o.paid_amount).to eq 57.60
      expect(o.net_amount_received).to eq 55.20
      expect(o.total_fee_amount).to eq 2.40

    end

  end

end
