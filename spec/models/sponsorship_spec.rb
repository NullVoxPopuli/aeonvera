# frozen_string_literal: true
# == Schema Information
#
# Table name: sponsorships
#
#  id             :integer          not null, primary key
#  sponsor_id     :integer
#  sponsor_type   :string
#  sponsored_id   :integer
#  sponsored_type :string
#  discount_id    :integer
#  discount_type  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_sponsorships_on_discount_id_and_discount_type    (discount_id,discount_type)
#  index_sponsorships_on_sponsor_type_and_sponsor_id      (sponsor_type,sponsor_id)
#  index_sponsorships_on_sponsored_type_and_sponsored_id  (sponsored_type,sponsored_id)
#

require 'rails_helper'

RSpec.describe Sponsorship, type: :model do
  describe 'relationships' do
    it 'can access sponsors' do
      e = create(:event)
      s = create(:sponsorship, sponsored: e, discount: create(:discount, host: e))

      expect(s.sponsor.sponsored_events).to include(s.sponsored)
      expect(s.sponsored.sponsoring_organizations).to include(s.sponsor)
    end
  end
end
