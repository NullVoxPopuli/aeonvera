require 'spec_helper'

describe Api::PricingTierPolicy do
  let(:by_owner){
    ->(method){
      tier = create(:pricing_tier)
      policy = Api::PricingTierPolicy.new(tier.event.hosted_by, tier)
      policy.send(method)
    }
  }

  let(:by_registrant){
    ->(method){
      event = create(:event)
      tier = create(:pricing_tier, event: event)
      attendance = create(:registration, host: event, pricing_tier: tier)

      policy = Api::PricingTierPolicy.new(attendance.attendee, tier)
      policy.send(method)
    }
  }

  context 'can be read?' do

    it 'by the event owner' do
      result = by_owner.call(:read?)
      expect(result).to eq true
    end

    it 'by a registrant' do
      result = by_registrant.call(:read?)
      expect(result).to eq true
    end
  end

  context 'can be updated?' do
    it 'by the event owner' do
      result = by_owner.call(:update?)
      expect(result).to eq true
    end

    it 'by a registrant' do
      result = by_registrant.call(:update?)
      expect(result).to eq false
    end
  end

  context 'can be created?' do
    it 'by the event owner' do
      result = by_owner.call(:create?)
      expect(result).to eq true
    end

    it 'by a registrant' do
      result = by_registrant.call(:create?)
      expect(result).to eq false
    end
  end

  context 'can be destroyed?' do
    it 'by the event owner' do
      result = by_owner.call(:delete?)
      expect(result).to eq true
    end

    it 'by a registrant' do
      result = by_registrant.call(:delete?)
      expect(result).to eq false
    end
  end

end
