# frozen_string_literal: true
require 'spec_helper'

describe HasMemberships do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  # assume duration is 1 year
  let(:membership_option) { create(:membership_option, organization: organization) }

  # sanity
  it 'has a 1 year membership' do
    expect(membership_option.duration).to eq 1.year
  end

  describe '#is_renewal_active?' do
    it 'is false when renewal is nil' do
      result = user.is_renewal_active?(nil)
      expect(result).to eq false
    end

    it 'retrieves a renewal from a membership' do
      expect(user).to receive(:latest_renewal_for_membership)
      user.is_renewal_active?(membership_option)
    end

    it 'returns true if the renewal is not expired' do
      renewal = create(:membership_renewal,
                       user: user,
                       membership_option: membership_option,
                       start_date: 1.month.ago)
      result = user.is_renewal_active?(renewal)
      expect(result).to eq true
    end

    it 'returns false if the renewal is expired' do
      renewal = create(:membership_renewal,
                       user: user,
                       membership_option: membership_option,
                       start_date: 13.months.ago)
      result = user.is_renewal_active?(renewal)
      expect(result).to eq false
    end
  end

  describe '#is_member_of?' do
    it 'has no active renewals' do
      result = user.is_member_of?(organization)
      expect(result).to eq false
    end

    it 'has one active renewal' do
      renewal = create(:membership_renewal,
                       user: user,
                       membership_option: membership_option,
                       start_date: 11.months.ago)

      result = user.is_member_of?(organization)
      expect(result).to eq true
    end
  end

  context 'many renewals' do
    before(:each) do
      @first_renewal = create(:membership_renewal,
                              user: user,
                              membership_option: membership_option,
                              start_date: 3.years.ago)
      @renewal = create(:membership_renewal,
                        user: user,
                        membership_option: membership_option,
                        start_date: 2.months.ago)
      @last_renewal = create(:membership_renewal,
                             user: user,
                             membership_option: membership_option,
                             start_date: 11.months.ago)
    end

    describe '#first_renewal_for_membership' do
      it 'retrieves the first renewal' do
        result = user.first_renewal_for_membership(membership_option)
        expect(result).to eq @first_renewal
      end

      it 'returns nothing for a non-membership' do
        result = user.first_renewal_for_membership(create(:membership_option))
        expect(result).to eq nil
      end
    end

    describe '#latest_renewal_for_membership' do
      it 'retrieves the last revewal' do
        result = user.latest_renewal_for_membership(membership_option)
        expect(result).to eq @last_renewal
      end

      it 'returns nothing for a non-membership' do
        result = user.latest_renewal_for_membership(create(:membership_option))
        expect(result).to eq nil
      end
    end
  end
end
