# frozen_string_literal: true
# == Schema Information
#
# Table name: restraints
#
#  dependable_id     :integer
#  dependable_type   :string(255)
#  restrictable_id   :integer
#  restrictable_type :string(255)
#  id                :integer          not null, primary key
#
# Indexes
#
#  index_restraints_on_dependable_id_and_dependable_type      (dependable_id,dependable_type)
#  index_restraints_on_restrictable_id_and_restrictable_type  (restrictable_id,restrictable_type)
#

require 'spec_helper'

describe Restraint do
  context 'a discount only affects a package' do
    let(:event) { create(:event) }
    let(:package) { create(:package, event: event) }
    let(:discount) {
      create(:discount, host: event,
                        kind: Discount::PERCENT_OFF, value: 100)
    }

    before(:each) do
      # make sure all the cached relationships are up to date
      event.reload
      package.reload
      discount.reload

      # assign discount to package
      create(:restraint, restrictable: package, dependable: discount)

      # build order
      @registration = create(:registration,
                             event: event,
                             pricing_tier: event.opening_tier)
    end

    it 'is applied to the assigned package' do
      @registration.package = package
      @registration.save!
      @order = create(:order,
                      registration: @registration,
                      host: event,
                      user: @registration.attendee)

      add_to_order(@order, package)
      add_to_order(@order, discount)

      # verify
      actual = @order.total
      expected = 0
      expect(actual).to eq expected
    end

    it 'is applied to an order without the assigned package' do
      @registration.package = wrong_package = create(:package, initial_price: 34, event: event)
      @registration.save!
      order = create(:order,
                     registration: @registration,
                     host: event,
                     user: @registration.attendee)

      add_to_order(order, wrong_package)
      oli = add_to_order(order, discount)
      expect(oli).to_not be_valid
      remove_invalid_items(order) # simulate not saving
      expect(order.order_line_items.count).to eq 1

      # verify
      actual = order.total
      expected = wrong_package.initial_price
      expect(actual).to eq expected
    end

    it 'no restraint is applied when no discount is present' do
      @registration.package = package
      @registration.save!
      @order = create(:order,
                      registration: @registration,
                      host: event,
                      user: @registration.attendee)

      add_to_order(@order, package)

      actual = @order.total
      expected = package.current_price
      expect(actual).to eq expected
    end

    it 'is only applied to the assigned package' do
      @registration.package = package
      @registration.save!
      @order = create(:order,
                      registration: @registration,
                      host: event,
                      user: @registration.attendee)

      add_to_order(@order, package)
      # add other stuff
      competition = create(:competition, event: event, kind: Competition::SOLO_JAZZ)
      oli = add_to_order(@order, competition)

      # add discount to order
      add_to_order(@order, discount, price: 0 - package.current_price)

      # verify
      actual = @order.total
      expected = competition.current_price
      expect(actual).to eq expected
    end
  end

  context 'a tier affects packages' do
    let(:event) { create(:event) }
    let(:package) { create(:package, event: event) }
    let(:tier) { create(:pricing_tier, date: Date.yesterday,
                                       event: event, increase_by_dollars: 11)
    }

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
