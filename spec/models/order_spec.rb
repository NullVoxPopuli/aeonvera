require 'spec_helper'

describe Order do

  describe 'validations' do

    describe 'buyer_email' do
      it 'is invalid with no email' do
        o = create(:order, host: create(:organization))
        o.user = nil
        expect(o).to_not be_valid
        expect(o.errors.keys).to include(:buyer_email)
      end

      it 'is present in the metadata' do
        o = create(:order, host: create(:organization))
        o.buyer_email = 'email@email.email'
        expect(o).to be_valid
        expect(o.errors.keys).to_not include(:buyer_email)
      end

      it 'is on the attendance' do
        o = create(:order, attendance: create(:attendance))
        expect(o).to be_valid
        expect(o.errors.keys).to_not include(:buyer_email)
      end

      it 'is on the user' do
        o = create(:order, user: create(:user), host: create(:organization))
        expect(o).to be_valid
        expect(o.errors.keys).to_not include(:buyer_email)
      end
    end

    describe 'buyer_name' do
      it 'is invalid with no user name' do
        o = create(:order, host: create(:organization))
        o.user = nil
        expect(o).to_not be_valid
        expect(o.errors.keys).to include(:buyer_name)
      end


      it 'is present in the metadata' do
        o = create(:order, host: create(:organization))
        o.buyer_name = 'test test'
        expect(o).to be_valid
        expect(o.errors.keys).to_not include(:buyer_name)
      end

      it 'is on the attendance' do
        o = create(:order, attendance: create(:attendance))
        expect(o).to be_valid
        expect(o.errors.keys).to_not include(:buyer_name)
      end

      it 'is on the user' do
        o = create(:order, user: create(:user), host: create(:organization))
        expect(o).to be_valid
        expect(o.errors.keys).to_not include(:buyer_name)
      end
    end
  end


  describe "#before_create" do

    it "payer_id is not set" do
      Order.any_instance.stub(:total).and_return(1.00)
      o = create(:order, host: create(:organization))
      o.payer_id.should_not == "0"
    end

    context "total is not 0" do
      let(:order){
        Order.any_instance.stub(:total).and_return(1.0)
        create(:order, host: create(:organization))
      }

      it "is not paid after creation" do
        order.paid?.should == false
      end

    end

    context "total is 0" do
      it "is paid afetr creation" do
        order = build(:order, host: create(:organization))
        allow(order).to receive(:total){ 0.0 }
        order.save
        order.paid?.should == true
      end

    end
  end

  describe "#force_paid!" do
    it "becomes paid" do
      o = Order.new
      o.paid?.should == false
    end
  end

  describe '#owes' do

    it 'has not been paid' do
      o = Order.new
      allow(o).to receive(:total){ 10 }

      expect(o.owes).to eq 10
    end

    it 'has been paid' do
      o = Order.new
      allow(o).to receive(:total){ 10 }
      allow(o).to receive(:paid?){ true }

      expect(o.owes).to eq 0
    end

  end

  describe '#check_stripe_validity' do
    it 'is invalid (somehow)' do
      o = Order.new
      o.host = create(:organization)
      allow(o).to receive(:total){ 10 }
      o.payment_method = Payable::Methods::STRIPE
      o.paid = true
      o.buyer_email = 'a@a.a'
      o.buyer_name = 'test test'
      paid_amount = nil
      o.save

      expect(o.paid).to eq false
    end
  end


  describe 'package + discount' do
    let(:event){ create(:event) }
    let(:order){ Order.new(event: event) }
    let(:discount){ create(:discount, host: event) }
    let(:package){ create(:package, event: event) }

    it 'discounts a dollar amount' do
      discount.kind = Discount::DOLLARS_OFF
      discount.amount = 10
      discount.save

      order.add(package)
      order.add(discount)

      expected = package.current_price - discount.amount
      actual = order.total
      expect(actual).to eq expected
    end

    it 'does not apply if the wrong package is selected' do
      wrong_package = create(:package, event: event)
      discount.allowed_packages << package

      order.add(wrong_package)
      order.add(discount)

      expect(order.line_items).to_not include(discount)
    end

    it 'does not modify price if the wrong package is selected' do
      wrong_package = create(:package, event: event)
      discount.allowed_packages << package
      discount.kind = Discount::DOLLARS_OFF
      discount.amount = 10
      discount.save

      order.add(wrong_package)
      order.add(discount)

      expected = package.current_price
      expect(order.total).to eq expected
    end

    it 'does not go negative' do
      discount.kind = Discount::DOLLARS_OFF
      discount.amount = package.current_price + 10
      discount.save

      order.add(package)
      order.add(discount)

      expect(order.total).to eq 0
    end

    context 'a tier is triggered, but is tied to a specific package' do
      let(:tier){ create(:pricing_tier, event: event, date: 1.week.ago, increase_by_dollars: 11) }

      before(:each) do
        allow(event).to receive(:current_tier){tier}
      end

      it 'increases the price of a package' do
        tier.allowed_packages << package
        expected = package.initial_price + tier.increase_by_dollars

        order.add(package)
        expect(order.total).to eq expected
      end

      it 'does not increase the price of a package' do
        different_package = create(:package, event: event, initial_price: 11.11)
        tier.allowed_packages << different_package
        expected = package.initial_price

        order.add(package)
        expect(order.total).to eq expected
        expect(order.total).to_not eq different_package.initial_price
      end

    end

    context 'a tier has increased the price of a package' do
      let(:tier){ create(:pricing_tier, event: event, date: 1.week.ago, increase_by_dollars: 11) }

      before(:each) do
        allow(event).to receive(:current_tier){tier}
        expect(package.current_price).to eq package.initial_price + tier.increase_by_dollars
      end

      it 'reduces the amount by a %' do
        discount.kind == Discount::PERCENT_OFF
        discount.percent = 50
        discount.save

        order.add(package)
        order.add(discount)

        price = package.current_price

        expected = price - price * (discount.percent / 100.0)
        expect(order.total).to eq expected
      end

      it 'reduces to free' do
        discount.kind == Discount::PERCENT_OFF
        discount.percent = 100
        discount.save

        order.add(package)
        order.add(discount)

        expected = 0
        expect(order.total).to eq expected
      end

      context 'other items are in the order' do

        it 'reduces the amount by a %' do

        end

        it 'reduces to free' do

        end

      end

    end

  end
end
