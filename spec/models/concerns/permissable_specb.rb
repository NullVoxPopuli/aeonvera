require 'spec_helper'

describe Permissable do

  before(:each) do
    @user = create(:user)
  end

  describe "process_permission" do
    before(:each) do
      @event = create(:event, user: @user)
      @collaborator = create(:user)

      @event.collaborators << @collaborator
      @event.save
    end

    it 'allows a permission' do
      result = @user.can_view_collaborators?(@event)
      expect(result).to eq true
    end

    it 'disallows a permission' do
      result = @collaborator.can_view_collaborators?(@event)
      expect(result).to eq false
    end

    it 'sets cache' do

    end

    it 'returns from cache' do

    end
  end

  describe "can?" do

    it 'gets the default value' do
      result = @user.send(:can?, DefaultPermissions::PERMISSIONS.keys.first)
      expect(result).to eq true
    end

    it 'gets the value from a pre-defined set' do
      key = DefaultPermissions::PERMISSIONS.keys.first
      result = @user.send(:can?, key, Permissable::IS_OWNER, { key.to_s => false } )
      expect(result).to eq false
    end
  end

  describe "get_ownership_status_of" do
    before(:each) do
      @collaborator = create(:user)
      @unrelated = create(:user)
    end

    context 'event' do
      before(:each) do
        @event = create(:event, user: @user)
      end

      it 'is owner' do
        result = @user.send(:get_ownership_status_of, @event)
        expect(result).to eq Permissable::IS_OWNER
      end

      it 'is collaborator' do
        @event.collaborators << @collaborator
        @event.save
        result = @collaborator.send(:get_ownership_status_of, @event)
        expect(result).to eq Permissable::IS_COLLABORATER
      end

      it 'is unrelated' do
        result = @unrelated.send(:get_ownership_status_of, @event)
        expect(result).to eq Permissable::IS_UNRELATED
      end
    end

    context 'organization' do
      before(:each) do
        @organization = create(:organization, user: @user)
      end

      it 'is owner' do
        result = @user.send(:get_ownership_status_of, @organization)
        expect(result).to eq Permissable::IS_OWNER
      end

      it 'is collaborator' do
        @organization.collaborators << @collaborator
        @organization.save
        result = @collaborator.send(:get_ownership_status_of, @organization)
        expect(result).to eq Permissable::IS_COLLABORATER
      end

      it 'is unrelated' do
        result = @unrelated.send(:get_ownership_status_of, @organization)
        expect(result).to eq Permissable::IS_UNRELATED
      end
    end

    context 'child object' do
      before(:each) do
        @event = create(:event, user: @user)
        @discount = create(:discount, event: @event)
      end

      it 'is owner' do
        result = @user.send(:get_ownership_status_of, @discount)
        expect(result).to eq Permissable::IS_OWNER
      end

      it 'is collaborator' do
        @event.collaborators << @collaborator
        @event.save
        result = @collaborator.send(:get_ownership_status_of, @discount)
        expect(result).to eq Permissable::IS_COLLABORATER
      end

      it 'is unrelated' do
        result = @unrelated.send(:get_ownership_status_of, @discount)
        expect(result).to eq Permissable::IS_UNRELATED
      end
    end
  end

  describe "collaborator_or_owner" do

    context 'event' do
      before(:each) do
        @event = create(:event, hosted_by: @user)
      end

      context 'owner' do

        it 'event' do
          result = @user.send(:collaborator_or_owner, @event)
          expect(result).to eq Permissable::IS_OWNER
        end

      end

      context 'collaborator' do
        before(:each) do
          @user2 = create(:user)
          @event.collaborators << @user2
          @event.save
        end

        it 'is an owner' do
          result = @user2.send(:collaborator_or_owner, @event)
          expect(result).to eq Permissable::IS_COLLABORATER
        end
      end
    end

    context 'organization' do
      before(:each) do
        @organization = create(:organization, user: @user)
      end

      context 'owner' do
        it 'organization' do
          result = @user.send(:collaborator_or_owner, @organization)
          expect(result).to eq Permissable::IS_OWNER
        end
      end

      context 'collaborator' do
        before(:each) do
          @user2 = create(:user)
          @organization.collaborators << @user2
          @organization.save
        end

        it 'is an owner' do
          result = @user2.send(:collaborator_or_owner, @organization)
          expect(result).to eq Permissable::IS_COLLABORATER
        end
      end
    end
  end

  describe "value_from_permission_cache" do

  end

  describe "set_permission_cache" do

  end

end
