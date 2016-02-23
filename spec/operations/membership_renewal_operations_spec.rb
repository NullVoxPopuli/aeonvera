require 'spec_helper'

describe MembershipRenewalOperations do
  let(:klass){ MembershipRenewalOperations }

  context 'ReadAll' do
    context 'organization' do
      it 'returns the organization' do
        organization = create(:organization)
        op = klass::ReadAll.new(organization.owner, {organization_id: organization.id}, {})

        expect(op.send(:organization)).to eq organization
      end

      it 'errors if a non-team-member accesses' do

      end
    end

    context 'renewals' do
      it 'flattens the renewals' do
        organization = create(:organization)
        option = create(:membership_option, organization: organization)
        option2 = create(:membership_option, organization: organization)
        create(:membership_renewal, membership_option: option)
        create(:membership_renewal, membership_option: option2)

        op = klass::ReadAll.new(organization.owner, {organization_id: organization.id}, {})
        result = op.send(:renewals)

        result.each do |renewal|
          expect(renewal).to be_a_kind_of(MembershipRenewal)
        end
      end
    end

    context 'latest_renewals' do
      it 'does not return multiple renewals for a user' do
        organization = create(:organization)
        user = create(:user)
        option = create(:membership_option, organization: organization)
        option2 = create(:membership_option, organization: organization)
        create(:membership_renewal, membership_option: option2, user: user, updated_at: 3.months.ago)
        recent = create(:membership_renewal, membership_option: option, user: user, updated_at: 2.months.ago)
        create(:membership_renewal, membership_option: option, user: user, updated_at: 4.months.ago)

        op = klass::ReadAll.new(organization.owner, {organization_id: organization.id}, {})
        result = op.send(:latest_renewals)

        expect(result.count).to eq 1
        expect(result.first).to eq recent
      end
    end
  end

end
