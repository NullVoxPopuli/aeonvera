require 'spec_helper'

describe Order do

  describe "#before_create" do

    it "payer_id is set" do
      o = Order.new(event: create(:event), payment_method: Payable::Methods::CASH)
      o.save
      o.reload
      o.paid?.should == true
      o.payer_id.should == "0"
    end

    it "payer_id is not set" do
      Order.any_instance.stub(:total).and_return(1.00)
      o = create(:order)
      o.payer_id.should_not == "0"
    end

    context "total is not 0" do
      let(:order){Order.any_instance.stub(:total).and_return(1.0); create(:order)}

      it "is not paid after creation" do
        order.paid?.should == false
      end

    end

    context "total is 0" do
      let(:order){Order.any_instance.stub(:total).and_return(0.0); create(:order)}

      it "is paid afetr creation" do
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
