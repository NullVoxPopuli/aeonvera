require 'spec_helper'

describe PackagePolicy do

  context 'can be read?' do

    it 'by the event owner' do
      package = create(:package)
      policy = PackagePolicy.new(package.event.hosted_by, package)
      result = policy.read?

      expect(result).to eq true
    end

    it 'by a registrant' do

    end
  end

  context 'can be updated?' do


  end

  context 'can be created?' do

  end

  context 'can be destroyed?' do

  end

end
