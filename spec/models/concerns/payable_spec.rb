# frozen_string_literal: true

require 'spec_helper'

# generate some line items
def line_item(options = {})
  {
    price: (rand * 100).round(2),
    quantity: (rand * 100).to_i,
    name: 'test item'
  }.merge(options)
end

def order_line_item(_options = {})
  LineItem.new(
    event: @event,
    name: 'test order line item',
    price: 5
  )
end

describe Payable do
  before(:each) do
    @event = create(:event, make_attendees_pay_fees: false)
    @registration = create(:registration, event: @event)
    @registration.save!
    @payment = create(:order, host: @event, registration: @registration)
  end

  context 'already_exists?' do
    before(:each) do
      @discount = Discount.new(host: @event, name: 'test', value: 3)
      @discount.save
    end

    it 'already includes a discount' do
      add_to_order(@payment, @discount)
      expect(@payment.already_exists?(@discount)).to be_truthy
    end

    it 'has no items' do
      expect(@payment.already_exists?(@discount)).to be_falsey
    end
  end

  context 'line_item_matching' do
    before(:each) do
      @one = order_line_item
      @one.save

      add_to_order(@payment, @one)
    end

    it 'retrieves the first line item' do
      line_item = @payment.line_item_matching(@one).line_item
      expect(line_item).to eq @one
    end
  end

  context 'total' do
    it 'is zero when the subtotal is zero' do
      package = create(:package, event: @event)
      discount = create(:discount, host: @event, value: 100, kind: Discount::PERCENT_OFF)
      order = create(:order, host: @event, registration: @registration)

      add_to_order!(order, package)
      add_to_order!(order, discount)

      expect(order.sub_total).to eq 0
      expect(order.total).to eq 0
      expect(order.application_fee).to eq 0
    end

    it 'totals when the package has a value of 0' do
      package = create(:package, event: @event, initial_price: 0, at_the_door_price: 0)
      friday_dance = create(:line_item, event: @event, price: 25)
      order = Order.new(host: @event, registration: @registration)
      add_to_order!(order, package)
      add_to_order!(order, friday_dance)

      expect(order.payment_method).to eq 'Cash'
      expect(order.sub_total).to eq 25
      expect(order.application_fee.round(2)).to eq 0.19 # not applied
      expect(order.total).to eq 25
    end

    it 'totals everything' do
      add_to_order!(@payment, order_line_item)
      add_to_order!(@payment, order_line_item, quantity: 2)

      expect(@payment.total).to eq 15
    end

    it 'has a discount' do
      add_to_order!(@payment, order_line_item)
      add_to_order!(@payment, order_line_item, quantity: 2)

      discount = create(:discount, host: @event, value: 10, kind: Discount::DOLLARS_OFF)
      add_to_order!(@payment, discount)

      expect(@payment.total).to eq 5
    end

    it 'never has a negative total' do
      discount = Discount.new(host: @event, name: 'test', value: 10_000)
      discount.save

      add_to_order!(@payment, order_line_item)
      add_to_order!(@payment, discount)

      expect(@payment.total).to eq 0
    end
  end

  context 'add_custom_item' do
    it 'adds a line item' do
      @payment.send(:legacy_line_items).should == []
      @payment.add_custom_item(
        price: 5,
        quantity: 10,
        name: 'test'
      )
      @payment.legacy_line_items.length.should == 1
    end

    it 'adds two line items' do
      @payment.legacy_line_items.should == []
      @payment.add_custom_item(
        price: 5,
        quantity: 10,
        name: 'test'
      )
      @payment.add_custom_item(
        price: 5,
        quantity: 10,
        name: 'test2'
      )
      @payment.legacy_line_items.length.should == 2
    end
  end

  context 'legacy_line_items_total' do
    it 'totals up line items' do
      a = line_item
      b = line_item

      @payment.add_custom_item(a)
      @payment.add_custom_item(b)
      total = (a[:price] * a[:quantity] + b[:price] * b[:quantity]).round(2)
      @payment.legacy_line_items_total.to_f.should == total.to_f
    end
  end

  context 'fee' do
    it 'is the most expensive teir' do
      @payment.stub(:total).and_return(150)
      @payment.application_fee.should == 150 * 0.0075
    end

    it 'is the middle teir' do
      @payment.stub(:total).and_return(25)
      @payment.application_fee.should == 25 * 0.0075
    end

    it 'is the lowest teir' do
      @payment.stub(:total).and_return(10)
      @payment.application_fee.should == 10 * 0.0075
    end
  end

  context 'total' do
    before(:each) do
      @payment.stub(:legacy_line_items).and_return(
        [line_item, line_item]
      )
    end
    it 'is the same as legacy_line_items_total without discounts' do
      @payment.legacy_total.should == @payment.legacy_line_items_total
    end

    context 'with discount on' do
      context 'final price' do
        it 'applies a percentage discount' do
          @payment.stub(:discounts).and_return(
            [
              {
                amount: 100,
                kind: Discount::PERCENT_OFF,
                to: Discount::AFFECTS_FINAL_PRICE
              }
            ]
          )

          @payment.legacy_total.should == 0
        end

        it 'applies a partial percentage discount' do
          @payment.stub(:discounts).and_return(
            [
              {
                amount: 50,
                kind: Discount::PERCENT_OFF,
                to: Discount::AFFECTS_FINAL_PRICE
              }
            ]
          )

          @payment.legacy_total.should == (@payment.send(:legacy_line_items_total) * 0.5).round(2)
        end

        it 'applies a dollar discount' do
          @payment.stub(:discounts).and_return(
            [
              {
                amount: 2,
                kind: Discount::DOLLARS_OFF,
                to: Discount::AFFECTS_FINAL_PRICE
              }
            ]
          )

          @payment.legacy_total.should == (@payment.legacy_line_items_total - 2).round(2)
        end

        it 'cannot end up with a negative total' do
          @payment.stub(:discounts).and_return(
            [
              {
                amount: @payment.send(:legacy_line_items_total) + 20,
                kind: Discount::DOLLARS_OFF,
                to: Discount::AFFECTS_FINAL_PRICE
              }
            ]
          )

          @payment.total.should == 0
        end
      end

      context 'package' do
        pending 'not implemented'
      end

      context 'competition' do
        pending 'not implemented'
      end

      context 'line_item' do
        pending 'not implemented'
      end
    end
  end
end
