require 'spec_helper'

describe OrderPolicy do
  context 'for collaborators' do
    context 'accessing data from an event' do
      let(:event) { create(:event) }
      let(:other_user) { create(:user) }
      let(:order) { create(:order, host: event, attendance: create(:attendance, host: event)) }

      let(:policy) { OrderPolicy.new(other_user, order) }

      before(:each) do
        event.collaborators << other_user
        event.save
      end

      it { expect(policy.read?).to eq true }
      it { expect(policy.update?).to eq true }
      it { expect(policy.delete?).to eq false }
    end
  end
end
