require 'rails_helper'

RSpec.describe Sponsorship, type: :model do
  describe 'relationships' do
    it 'can access sponsors' do
      s = create(:sponsorship)

      expect(s.sponsor.sponsored_events).to include(s.sponsored)
      expect(s.sponsored.sponsoring_organizations).to include(s.sponsor)
    end
  end
end
