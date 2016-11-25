# == Schema Information
#
# Table name: orders
#
#  id                          :integer          not null, primary key
#  payment_token               :string(255)
#  payer_id                    :string(255)
#  metadata                    :text
#  attendance_id               :integer
#  host_id                     :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  paid                        :boolean          default(FALSE), not null
#  payment_method              :string(255)      default("Cash"), not null
#  paid_amount                 :decimal(, )
#  net_amount_received         :decimal(, )      default(0.0), not null
#  total_fee_amount            :decimal(, )      default(0.0), not null
#  user_id                     :integer
#  host_type                   :string(255)
#  payment_received_at         :datetime
#  pricing_tier_id             :integer
#  current_paid_amount         :decimal(, )      default(0.0), not null
#  current_net_amount_received :decimal(, )      default(0.0), not null
#  current_total_fee_amount    :decimal(, )      default(0.0), not null
#  created_by_id               :integer
#
# Indexes
#
#  index_orders_on_created_by_id          (created_by_id)
#  index_orders_on_host_id_and_host_type  (host_id,host_type)
#  index_orders_on_pricing_tier_id        (pricing_tier_id)
#  index_orders_on_user_id                (user_id)
#

require 'spec_helper'

describe Order do

  describe 'associations' do
    context 'line_Items' do

      it 'has line items' do
        discount = Discount.new
        discount.save(validate: false)

        order = Order.new
        order.save(validate: false)

        oli = OrderLineItem.new(order: order, line_item: discount)
        oli.save(validate: false)

        order.reload
        expect(order.line_items.first).to eq discount
      end
    end
  end

  describe 'validations' do

    describe 'attendance' do
      it 'is required when there is a competition' do
        event = create(:event)
        competition = create(:competition, event: event)
        order = build(:order, host: event)
        oli = add_to_order(order, competition)
        oli.dance_orientation = 'Lead'

        order.valid?
        expect(order.errors.full_messages).to_not be_empty
        expect(order).to_not be_valid
      end
    end

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

  describe 'sub_total' do
    it 'totals negative amounts' do
      event = create(:event)
      o = create(:order, host: event)
      package = create(:package, event: event)
      add_to_order!(o, package, quantity: -1)

      expect(o.sub_total).to eq 0 - package.current_price
      expect(o.total).to eq 0 - package.current_price
    end

    it 'min amount is 0 when all quantities are positive' do
      event = create(:event)
      o = create(:order, host: event)
      package = create(:package, event: event)
      add_to_order(o, package, quantity: 1)

      expect(o.sub_total).to eq package.current_price
      expect(o.total).to eq package.current_price
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

      add_to_order(order, package)
      add_to_order(order, discount)

      expected = package.current_price - discount.amount
      actual = order.total
      expect(actual).to eq expected
    end

    it 'does not apply if the wrong package is selected' do
      wrong_package = create(:package, event: event)
      discount.allowed_packages << package

      add_to_order(order, wrong_package)
      add_to_order(order, discount)

      expect(order.line_items).to_not include(discount)
    end

    it 'does not modify price if the wrong package is selected' do
      wrong_package = create(:package, event: event)
      discount.allowed_packages << package
      discount.kind = Discount::DOLLARS_OFF
      discount.amount = 10
      discount.save

      oli = add_to_order(order, wrong_package)
      expect(oli).to be_valid

      oli = add_to_order(order, discount)
      expect(oli).to_not be_valid
      remove_invalid_items(order) # instead of saving, remove invalid


      expected = package.current_price
      expect(order.total).to eq expected
    end

    it 'does not go negative' do
      discount.kind = Discount::DOLLARS_OFF
      discount.amount = package.current_price + 10
      discount.save

      add_to_order(order, package)
      add_to_order(order, discount)

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

        oli = add_to_order(order, package)
        expect(oli).to be_valid
        expect(order.total).to eq expected
      end

      it 'does not increase the price of a package' do
        different_package = create(:package, event: event, initial_price: 11.11)
        tier.allowed_packages << different_package
        expected = package.initial_price

        add_to_order(order, package)
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

        add_to_order(order, package)
        add_to_order(order, discount)

        price = package.current_price

        expected = price - price * (discount.percent / 100.0)
        expect(order.total).to eq expected
      end

      it 'reduces to free' do
        discount.kind == Discount::PERCENT_OFF
        discount.percent = 100
        discount.save

        add_to_order(order, package)
        add_to_order(order, discount)

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
