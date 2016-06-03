require 'rails_helper'

describe Api::Users::CollaborationsController, type: :request do
  let(:user) { create(:user) }

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json' if defined? request
    host! APPLICATION_CONFIG[:domain][Rails.env]
  end

  context 'events' do
    let(:event) { create(:event) }
    before(:each) do
      # create an invitation
      options = { email: user.email, host_type: Event.name, host_id: event.id }
      op = CollaborationOperations::Create.new(user, options)
      op.run
      @token = op.token_from_email
    end

    it 'errors when not logged in' do
      put "/api/users/collaborations?token=#{@token}&host_id=#{event.id}&host_type=#{Event.name}"
      expect(response.status).to eq 401
      expect(response.body).to include('401')
    end

    context 'is logged in' do
      before(:each) do
        @headers = {
          'Authorization' => 'Bearer ' + user.authentication_token
        }
      end

      it 'becomes a collaborator' do
        expect(Event.find(event.id).collaborator_ids).to_not include(user.id)

        put "/api/users/collaborations?token=#{@token}&host_id=#{event.id}&host_type=#{Event.name}", {}, @headers
        expect(response.status).to eq 200

        expect(Event.find(event.id).collaborator_ids).to include(user.id)
      end

      it 'cannot use the token twice' do
        expect(Event.find(event.id).collaborator_ids).to_not include(user.id)

        put "/api/users/collaborations?token=#{@token}&host_id=#{event.id}&host_type=#{Event.name}", {}, @headers
        expect(response.status).to eq 200

        expect(Event.find(event.id).collaborator_ids).to include(user.id)

        put "/api/users/collaborations?token=#{@token}&host_id=#{event.id}&host_type=#{Event.name}", {}, @headers
        expect(response.status).to eq 422
        expect(response.body).to include('Key not found or your user is not associated with the invited email')

        expect(Event.find(event.id).collaborator_ids).to include(user.id)
      end

      it 'is already a collaborator' do
        event.collaborators << user
        event.save

        put "/api/users/collaborations?token=#{@token}&host_id=#{event.id}&host_type=#{Event.name}", {}, @headers
        expect(response.status).to eq 422
        expect(response.body).to include('You are already helping with this Event')

        expect(Event.find(event.id).collaborator_ids).to include(user.id)
      end

      it 'owns the event' do
        event.hosted_by = user
        event.save

        put "/api/users/collaborations?token=#{@token}&host_id=#{event.id}&host_type=#{Event.name}", {}, @headers
        expect(response.status).to eq 422
        expect(response.body).to include('You are already helping with this Event')

        expect(Event.find(event.id).collaborator_ids).to_not include(user.id)
      end

      it 'was not the intended recipient / invalid token' do
        expect(Event.find(event.id).collaborator_ids).to_not include(user.id)

        put "/api/users/collaborations?token=123&host_id=#{event.id}&host_type=#{Event.name}", {}, @headers
        expect(response.status).to eq 422
        expect(response.body).to include('Key not found or your user is not associated with the invited email')

        expect(Event.find(event.id).collaborator_ids).to_not include(user.id)
      end
    end
  end

  context 'organizations' do
    let(:organization) { create(:organization) }

    before(:each) do
      # create an invitation
      options = { email: user.email, host_type: Organization.name, host_id: organization.id }
      op = CollaborationOperations::Create.new(user, options)
      op.run
      @token = op.token_from_email

      @headers = {
        'Authorization' => 'Bearer ' + user.authentication_token
      }
    end

    it 'becomes a collaborator' do
      expect(Organization.find(organization.id).collaborator_ids).to_not include(user.id)

      put "/api/users/collaborations?token=#{@token}&host_id=#{organization.id}&host_type=#{Organization.name}", {}, @headers
      expect(response.status).to eq 200

      expect(Organization.find(organization.id).collaborator_ids).to include(user.id)
    end

  end
end
