require 'spec_helper'

describe User do
  describe '#owned_and_collaborated_organizations' do
    it 'owns an organization' do
      org = create(:organization, owner: create_confirmed_user)
      user = org.owner
      orgs = user.owned_and_collaborated_organizations

      expect(orgs).to include(org)
    end

    it 'collaborates on an organization' do
      org = create(:organization, owner: create_confirmed_user)
      user = create_confirmed_user
      org.collaborators << user
      org.save

      orgs = user.owned_and_collaborated_organizations

      expect(orgs).to include(org)
    end
  end

  context 'events' do
    let(:user) { create(:user) }

    before(:each) do
      @event = create(:event)
    end

    describe '#not_attending_event?' do
      it 'prevents deleting' do
        user.stub(:upcoming_events).and_return([@event])
        user.destroy
        expect(user.deleted?).to eq false
        expect(user.deleted_at).to eq nil
        expect(user.errors.full_messages.size).to eq 1
        expect(user.errors.full_messages.first).to include(@event.name)
      end

      it 'allows deleting' do
        user.destroy
        expect(user.deleted?).to eq true
        expect(user.errors.full_messages).to be_empty
      end
    end
  end
end
