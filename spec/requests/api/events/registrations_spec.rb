# frozen_string_literal: true

require 'rails_helper'

describe Api::Events::RegistrationsController, type: :request do
  base_path = '/api/events/registrations'

  context 'not logged in' do
    it_behaves_like(
      'unauthorized',
      factory:   :registration,
      base_path:   base_path
    )
  end

  context 'is logged in and owns the event' do
    it_behaves_like(
      'resource_accessed_by_event_owner', {
        type: 'registrations',
        factory: :registration,
        base_path: base_path,
        event_relationship_name: :host,
        undestroy: true
      }
    )

    it_behaves_like(
      'resource_has_csv_rendering', {
        type: 'registrations',
        factory: :registration,
        base_path: base_path,
        parent_relationship_name: :host,
        actions: [:index]
      }
    )
  end

  context 'is logged in but does not own the event' do
    it_behaves_like(
      'resource_accessed_by_random_user', {
        type: 'registrations',
        factory: :registration,
        base_path: base_path,
        event_relationship_name: :host
      }
    )

    context 'PUT /:id/checkin' do
      let(:user) { create_confirmed_user }
      let(:event) { create(:event) }
      let!(:registration) { create(:registration, host: event) }

      it 'is not allowed' do
        put(
          "/api/events/registrations/#{registration.id}/checkin",
          { checked_in_at: Time.now, event_id: event.id },
          auth_header_for(user)
        )

        expect(response.status).to eq 403
      end
    end

    context 'PUT /:id/uncheckin' do
      let(:user) { create_confirmed_user }
      let(:event) { create(:event) }
      let!(:registration) { create(:registration, host: event, attending: true) }

      it 'is not allowed' do
        put(
          "/api/events/registrations/#{registration.id}/uncheckin",
          { event_id: event.id },
          auth_header_for(user)
        )


        expect(response.status).to eq 403
      end
    end
  end

  context 'is logged in and the user is a collaborator' do
    it_behaves_like(
      'resource_accessed_by_collaborator_with_full_access', {
        type: 'registrations',
        factory: :registration,
        base_path: base_path,
        event_relationship_name: :host
      }
    )

    context 'PUT /:id/checkin' do
      let(:user) { create_confirmed_user }
      let(:event) { create(:event) }
      let!(:collaboration) { create(:collaboration, user: user, collaborated: event) }
      let!(:registration) { create(:registration, host: event) }

      it 'is allowed' do
        put(
          "/api/events/registrations/#{registration.id}/checkin",
          { checked_in_at: Time.now, event_id: event.id },
          auth_header_for(user)
        )

        expect(response.status).to eq 200
      end
    end

    context 'PUT /:id/uncheckin' do
      let(:user) { create_confirmed_user }
      let(:event) { create(:event) }
      let!(:collaboration) { create(:collaboration, user: user, collaborated: event) }
      let!(:registration) { create(:registration, host: event, attending: true) }

      it 'is allowed' do
        put(
          "/api/events/registrations/#{registration.id}/uncheckin",
          { event_id: event.id },
          auth_header_for(user)
        )

        expect(response.status).to eq 200
      end
    end
  end
end
