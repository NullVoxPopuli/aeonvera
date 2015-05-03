require "spec_helper"

# generate some line items
def line_item(options = {})
  {
    price: (rand * 100).round(2),
    quantity: (rand * 100).to_i,
    name: "test item"
  }.merge(options)
end

def order_line_item(options = {})
  LineItem.new(
    event: @event,
    name: "test order line item",
    price: 5
  )
end


describe Payable do
  before(:each) do
    @event = create(:event, make_attendees_pay_fees: false)
    @attendance = create(:attendance, event: @event)
    @attendance.save!
    @payment = create(:order, event: @event, attendance: @attendance)
  end

  context "increment_quantity_of_line_item_matching" do
    before(:each) do
      @one = order_line_item
      @one.save
      @line_item = @payment.add(@one)
    end

    it 'increments the quantity' do
      expect{
        @payment.add(@one)
      }.to change(@line_item, :quantity).by 1
    end
  end

  context "already_exists?" do

    before(:each) do
      @discount = Discount.new(event: @event, name: 'test', value: 3)
      @discount.save
    end

    it 'already includes a discount' do
      @payment.add(@discount)
      expect(@payment.already_exists?(@discount)).to be_truthy
    end

    it 'has no items' do
      expect(@payment.already_exists?(@discount)).to be_falsey
    end
  end

  context "line_item_matching" do

    before(:each) do
      @one = order_line_item
      @one.save

      @payment.add(@one)
    end

    it "retrieves the first line item" do
      line_item = @payment.line_item_matching(@one).line_item
      expect(line_item).to eq @one
    end

    it "adding two of the same still returns the first line item" do
      @payment.add(@one)
      line_item = @payment.line_item_matching(@one).line_item
      expect(line_item).to eq @one
    end
  end

  context "add" do
    it "adds an order line item" do
      @payment.line_items.should be_empty
      @payment.add(order_line_item)
      @payment.line_items.count.should == 1
    end


    it "adds any line item only once" do
      item = order_line_item
      item.save
      @payment.add(item)
      expect(@payment.line_items.count).to eq 1
      @payment.add(item)
      expect(@payment.line_items.count).to eq 1
    end

    it "maintains a reference to the original object" do
      item1 = order_line_item
      item1.save
      @payment.add(item1)
      item = @payment.line_items.first
      item.should be_kind_of OrderLineItem
      item.line_item.id.should == item1.id
    end

    context 'discounts' do

      before(:each) do
        @discount =  Discount.create(event: @event, name: 'test', value: 3)
        @discount2 =  Discount.create(event: @event, name: 'test2', value: 3)
        @event.allow_combined_discounts = true
        @event.save
      end

      it "adds the same discount only once" do
        @payment.add(@discount)
        expect(@payment.line_items.count).to eq 1
        @payment.add(@discount)
        expect(@payment.line_items.count).to eq 1
      end

      it "adds multiple discounts" do
        @payment.add(@discount)
        @payment.add(@discount2)

        expect(@payment.line_items.count).to eq 2
      end

      it "allows only one discount to be added" do
        @event.allow_combined_discounts = false
        @event.save
        @payment.reload
        @payment.add(@discount)
        @payment.add(@discount2)

        expect(@payment.line_items.count).to eq 1
      end

      it "doesn't allow any discounts" do
        @event.allow_discounts = false
        @event.save
        @payment.reload
        @payment.add(@discount)
        expect(@payment.line_items.count).to eq 0
      end
    end
  end

  context "total" do
    it "totals everything" do
      item1 = order_line_item
      item2 = order_line_item
      item1.save
      item2.save
      @payment.add(item1)
      @payment.add(item2, quantity: 2)

      expect(@payment.total).to eq 15
    end

    it "has a discount" do
      item1 = order_line_item
      item2 = order_line_item
      item1.save
      item2.save
      @payment.add(item1)
      @payment.add(item2, quantity: 2)

      discount = create(:discount, event: @event, value: 10, kind: Discount::DOLLARS_OFF)
      @payment.add(discount)

      expect(@payment.total).to eq 5
    end

    it 'never has a negative total' do
      discount = Discount.new(event: @event, name: 'test', value: 10000)
      discount.save
      @payment.add(order_line_item)
      @payment.add(discount)
      expect(@payment.total).to eq 0
    end
  end

  context "add_custom_item" do

    it "adds a line item" do
      @payment.send(:legacy_line_items).should == []
      @payment.add_custom_item(
        price: 5,
        quantity: 10,
        name: "test"
      )
      @payment.legacy_line_items.length.should == 1
    end

    it "adds two line items" do
      @payment.legacy_line_items.should == []
      @payment.add_custom_item(
        price: 5,
        quantity: 10,
        name: "test"
      )
      @payment.add_custom_item(
        price: 5,
        quantity: 10,
        name: "test2"
      )
      @payment.legacy_line_items.length.should == 2
    end
  end

  context "legacy_line_items_total" do

    it "totals up line items" do
      a = line_item
      b = line_item

      @payment.add_custom_item(a)
      @payment.add_custom_item(b)
      total = (a[:price] * a[:quantity] + b[:price] * b[:quantity]).round(2)
      @payment.legacy_line_items_total.to_f.should == total.to_f
    end

  end

  context "fee" do
    it "is the most expensive teir" do
      @payment.stub(:total).and_return(150)
      @payment.fee.should == 150 * 0.0075
    end

    it "is the middle teir" do
      @payment.stub(:total).and_return(25)
      @payment.fee.should == 25 * 0.0075
    end

    it "is the lowest teir" do
      @payment.stub(:total).and_return(10)
      @payment.fee.should == 10 * 0.0075
    end

  end

  context "total" do
    before(:each) do
      @payment.stub(:legacy_line_items).and_return(
        [line_item, line_item]
      )
    end
    it "is the same as legacy_line_items_total without discounts" do
      @payment.legacy_total.should == @payment.legacy_line_items_total
    end

    context "with discount on" do
      context "final price" do
        it "applies a percentage discount" do
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

        it "applies a partial percentage discount" do
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


        it "applies a dollar discount" do
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

        it "cannot end up with a negative total" do
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

      context "package" do
        pending "not implemented"
      end

      context "competition" do
        pending "not implemented"
      end

      context "line_item" do
        pending "not implemented"
      end
    end
  end
end
