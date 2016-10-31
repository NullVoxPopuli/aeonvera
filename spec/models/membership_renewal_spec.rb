require 'spec_helper'

describe MembershipRenewal do

  before(:each) do
    membership = create(:membership_option)
    user = create(:user)
    @renewal = create(:membership_renewal, user: user, membership_option: membership)
  end

  describe '#expired?' do
    it 'is expired when the expires at date is before today' do
      allow(@renewal).to receive(:expires_at){ 1.day.ago }
      expect(@renewal.expired?).to eq true
    end

    it 'is not expired when the expires at date is not before today' do
      allow(@renewal).to receive(:expires_at){ 1.day.from_now }
      expect(@renewal.expired?).to eq false
    end
  end

  describe '#expires_at' do
    it 'adds the duration to the start date' do
      now = Time.now
      @renewal.start_date = now
      allow(@renewal).to receive(:duration){ 1.week }
      expect(@renewal.expires_at.to_i).to eq (now + 1.week).to_i
    end
  end


end
