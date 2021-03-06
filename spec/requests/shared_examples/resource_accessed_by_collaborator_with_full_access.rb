# frozen_string_literal: true

require 'rails_helper'

shared_examples 'resource_accessed_by_collaborator_with_full_access' do |options = {}|
  factory_name = options[:factory]
  base_path = options[:base_path]
  relationship_name = options[:event_relationship_name]
  type = options[:type]
  destroy_status = options[:destroy] || 200

  let(:user) { create_confirmed_user }
  let(:event) { create(:event) }
  let!(:collaboration) { create(:collaboration, user: user, collaborated: event) }

  context 'index' do
    it 'succeeds' do
      get base_path, { event_id: event.id }, auth_header_for(user)

      expect(response.status).to eq 200
    end
  end

  context 'show' do
    it 'succeeds' do
      object = create(factory_name, event: event)
      get "#{base_path}/#{object.id}", { event_id: event.id }, auth_header_for(user)

      expect(response.status).to eq 200
    end
  end

  context 'create' do
    it 'succeeds' do
      post(base_path,
           { event_id: event.id }.merge(
             jsonapi_params(type,
                            attributes: attributes_for(factory_name),
                            relationships: { relationship_name => event })
           ),
           auth_header_for(user))

      expect(response.status).to eq 201
    end
  end

  context 'update' do
    it 'succeeds' do
      object = create(factory_name, event: event)

      put("#{base_path}/#{object.id}",
          { event_id: event.id }.merge(
            jsonapi_params(type,
                           id: object.id,
                           attributes: attributes_for(factory_name))
          ),
          auth_header_for(user))

      expect(response.status).to eq 200
    end
  end

  context 'destroy' do
    it "returns a #{destroy_status}" do
      object = create(factory_name, event: event)
      delete "#{base_path}/#{object.id}", { event_id: event.id }, auth_header_for(user)

      expect(response.status).to eq destroy_status
    end
  end
end
