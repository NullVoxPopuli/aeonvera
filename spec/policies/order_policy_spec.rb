require 'spec_helper'

describe Api::OrderPolicy do
  context 'for collaborators' do
    context 'accessing data from an event' do
      let(:event) { create(:event) }
      let(:other_user) { create(:user) }
      let(:order) { create(:order, host: event, attendance: create(:registration, host: event)) }

      let(:policy) { Api::OrderPolicy.new(other_user, order) }

      before(:each) do
        event.collaborators << other_user
        event.save
      end

      it { expect(policy.read?).to eq true }
      it { expect(policy.update?).to eq true }
      it { expect(policy.delete?).to eq false }
    end
  end

  context 'creator of the order' do
    let(:other_user) { create(:user) }

    it 'can delete unpaid orders' do
      order = build(:order, created_by: other_user, paid: false)
      policy = Api::OrderPolicy.new(other_user, order)

      expect(policy.delete?).to eq true
    end

    it 'cannot delete paid orders' do
      order = build(:order, created_by: other_user, paid: true)
      policy = Api::OrderPolicy.new(other_user, order)

      expect(policy.delete?).to eq false
    end
  end

  context 'owner of the event' do
    let(:event) { create(:event) }

    it 'can delete unpaid orders' do
      order = build(:order, host: event, paid: false)
      policy = Api::OrderPolicy.new(event.hosted_by, order)

      expect(policy.delete?).to eq true
    end

    it 'cannot delete paid orders' do
      order = build(:order, host: event, paid: true)
      policy = Api::OrderPolicy.new(event.hosted_by, order)

      expect(policy.delete?).to eq false
    end
  end
end
