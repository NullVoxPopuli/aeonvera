require 'spec_helper'

describe OrderOperations::Create do
  let(:klass){ OrderOperations::Create }
    # This is only for the parameter mapping
    let(:controller){ Api::OrdersController.new }

    let(:user){ create(:user) }
    let(:event){ create(:event) }
    let(:package){ create(:package, event: event) }
    let(:attendance){ create(:attendance, host: event, package: package, attendee: user) }


    context 'with a package and competition' do
      let(:competition){ create(:competition, event: event, kind: Competition::SOLO_JAZZ) }

      let(:basic_params){
        {"data"=>{
          "attributes"=>{
            "host-name"=>nil, "host-url"=>nil, "created-at"=>nil, "payment-received-at"=>nil, "paid-amount"=>nil, "net-amount-received"=>nil, "total-fee-amount"=>nil, "payment-method"=>nil, "payment-token"=>nil, "check-number"=>nil, "paid"=>false, "total-in-cents"=>nil,
            "user-email"=>"someone@test.com", "user-name"=>" ", "checkout-token"=>nil, "checkout-email"=>nil},
          "relationships"=>{
            "host"=>{"data"=>{"type"=>"events", "id"=>event.id}},
            "order-line-items"=>{"data"=>[
              {
                "attributes"=>{"quantity"=>1, "price"=>package.current_price, "partner-name"=>nil, "dance-orientation"=>nil, "size"=>nil, "payment-token"=>nil},
                "relationships"=>{
                  "line-item"=>{"data"=>{"type"=>"packages", "id"=>package.id}},
                  "order"=>{"data"=>{"type"=>"orders", "id"=>nil}}},
                "type"=>"order-line-items"},
              {
                "attributes"=>{"quantity"=>1, "price"=>competition.current_price, "partner-name"=>nil, "dance-orientation"=>nil, "size"=>nil, "payment-token"=>nil},
                "relationships"=>{
                  "line-item"=>{"data"=>{"type"=>"competitions", "id"=>competition.id}},
                  "order"=>{"data"=>{"type"=>"orders", "id"=>nil}}},
                "type"=>"order-line-items"},
                ]},
            "attendance"=>{"data"=>{"type"=>"event-attendances", "id"=>attendance.id}},
            "user"=>{"data"=>{"type"=>"users", "id"=>"current-user"}}}, "type"=>"orders"},
            "order"=>{}}
      }

      before(:each) do
        allow(controller).to receive(:params){ basic_params }
        params_for_action = controller.send(:create_order_params)

        @operation = klass.new(user, basic_params, params_for_action)
      end

      it 'is valid' do
        model = @operation.run
        expect(model.errors.full_messages).to be_empty
      end

      it 'creates an order' do
        expect{
          @operation.run
        }.to change(Order, :count).by(1)
      end

      it 'creates order line items' do
        expect{
          @operation.run
        }.to change(OrderLineItem, :count).by(2)
      end

      it 'defaults to the stripe payment method' do
        model = @operation.run
        expect(model.payment_method).to eq Payable::Methods::STRIPE
      end

      it 'has a subtotal equal to the sum of the line items' do
        model = @operation.run
        expected = package.current_price + competition.current_price
        expect(model.sub_total).to eq expected
      end

    end


    context 'the total is 0 dollas' do
      let(:basic_params){
        {"data"=>{
          "attributes"=>{
            "host-name"=>nil, "host-url"=>nil, "created-at"=>nil, "payment-received-at"=>nil, "paid-amount"=>nil, "net-amount-received"=>nil, "total-fee-amount"=>nil, "payment-method"=>nil, "payment-token"=>nil, "check-number"=>nil, "paid"=>false, "total-in-cents"=>nil,
            "user-email"=>"someone@test.com", "user-name"=>" ", "checkout-token"=>nil, "checkout-email"=>nil},
          "relationships"=>{
            "host"=>{"data"=>{"type"=>"events", "id"=>event.id}},
            "order-line-items"=>{"data"=>[
              {
                "attributes"=>{"quantity"=>1, "price"=>0, "partner-name"=>nil, "dance-orientation"=>nil, "size"=>nil, "payment-token"=>nil},
                "relationships"=>{
                  "line-item"=>{"data"=>{"type"=>"packages", "id"=>package.id}},
                  "order"=>{"data"=>{"type"=>"orders", "id"=>nil}}},
                "type"=>"order-line-items"},
                ]},
            "attendance"=>{"data"=>{"type"=>"event-attendances", "id"=>attendance.id}},
            "user"=>{"data"=>{"type"=>"users", "id"=>"current-user"}}}, "type"=>"orders"},
            "order"=>{}}
      }

      before(:each) do
        allow(controller).to receive(:params){ basic_params }
        params_for_action = controller.send(:create_order_params)

        @operation = klass.new(user, basic_params, params_for_action)
      end

      it 'marks as paid when the sub total is 0' do
        model = @operation.run
        expect(model.sub_total).to eq 0
        expect(model.paid).to eq true
      end

      it 'marks the payment method as cash' do
        model = @operation.run
        expect(model.payment_method).to eq Payable::Methods::CASH
      end
    end


    it 'charges the credit card' do
      # TODO: remember StripeMock
    end


end
