require 'spec_helper'

describe Api::PackagePolicy do
  let(:by_owner){
    ->(method){
      package = create(:package)
      policy = Api::PackagePolicy.new(package.event.hosted_by, package)
      policy.send(method)
    }
  }

  let(:by_registrant){
    ->(method){
      event = create(:event)
      package = create(:package, event: event)
      attendance = create(:attendance, host: event, package: package)

      policy = Api::PackagePolicy.new(attendance.attendee, package)
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
