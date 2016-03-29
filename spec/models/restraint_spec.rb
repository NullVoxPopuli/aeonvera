require 'spec_helper'

describe Restraint do

  context 'a discount only affects a package' do
    let(:event){ create(:event) }
    let(:package){ create(:package, event: event) }
    let(:discount){
      create(:discount, event: event,
      kind: Discount::PERCENT_OFF, value: 100 )
    }

    before(:each) do
      # make sure all the cached relationships are up to date
      event.reload
      package.reload
      discount.reload

      # assign discount to package
      create(:restraint, restrictable: package, dependable: discount)

      # build order
      @attendance = create(:attendance,
        event: event,
        pricing_tier: event.opening_tier
      )
    end


    it 'is applied to the assigned package' do
      @attendance.package = package
      @attendance.save!
      @order = create(:order,
        attendance: @attendance,
        host: event,
        user: @attendance.attendee
      )

      @order.add(package)
      # add discount to order
      @order.add(discount)

      # verify
      @order.reload
      actual = @order.total
      expected = 0
      expect(actual).to eq expected
    end

    it 'is applied to an order without the assigned package' do
      @attendance.package = wrong_package = create(:package, initial_price: 34)
      @attendance.save!
      @order = create(:order,
        attendance: @attendance,
        host: event,
        user: @attendance.attendee
      )

      @order.add(wrong_package)
      @order.add(discount)

      discounts = @order.line_items.where(line_item_type: Discount.name)
      expect(discounts).to be_empty

      # verify
      @order.reload
      actual = @order.total
      expected = wrong_package.initial_price
      expect(actual).to eq expected
    end

    it 'is only applied to the assigned package' do
      @attendance.package = package
      @attendance.save!
      @order = create(:order,
        attendance: @attendance,
        host: event,
        user: @attendance.attendee
      )
      @order.add(package)
      # add other stuff
      competition = create(:competition, event: event)
      @order.add(competition)

      # add discount to order
      @order.add(discount)

      # verify
      actual = @order.total
      expected = competition.current_price
      expect(actual).to eq expected
    end

  end


  context 'a tier affects packages' do
    let(:event){ create(:event) }
    let(:package){ create(:package, event: event) }
    let(:tier){ create(:pricing_tier, date: Date.yesterday,
      event: event, increase_by_dollars: 11) }

    before(:each) do
      # make sure all the cached relationships are up to date
      event.reload
      tier.reload
      package.reload
    end

    context 'without restraint' do
      context '#current_price' do
        it 'affects all packages' do
          package.reload
          event.reload

          actual = package.current_price
          expected = package.initial_price + tier.increase_by_dollars
          expect(actual).to eq expected
        end
      end

      context '#price_at_tier' do
        it 'affects all packages' do
          actual = package.price_at_tier(tier)
          expected = package.initial_price + tier.increase_by_dollars

          expect(actual).to eq expected
        end
      end

    end

    context 'with restraint' do

      before(:each) do
        create(:restraint, restrictable: package, dependable: tier)
      end

      context '#current_price' do
        it 'increments the affected package' do
          actual = package.current_price
          expected = package.initial_price + tier.increase_by_dollars

          expect(actual).to eq expected
        end

        it 'does not affect additional packages' do
          new_package = create(:package, event: event)
          actual = new_package.current_price
          expected = new_package.initial_price

          expect(actual).to eq expected
        end
      end

      context '#price_at_tier' do
        it 'increments the affected package' do
          actual = package.price_at_tier(tier)
          expected = package.initial_price + tier.increase_by_dollars

          expect(actual).to eq expected
        end

        it 'does not affect additional packages' do
          new_package = create(:package, event: event)
          actual = new_package.current_price
          expected = new_package.initial_price

          expect(actual).to eq expected
        end
      end
    end
  end
end
