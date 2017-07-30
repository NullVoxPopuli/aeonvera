# frozen_string_literal: true

require 'rails_helper'

shared_examples 'resource_accessed_by_random_user' do |options = {}|
  factory_name = options[:factory]
  base_path = options[:base_path]
  relationship_name = options[:event_relationship_name]
  type = options[:type]

  let(:user) { create_confirmed_user }
  let(:event) { create(:event) }

  context 'index' do
    it 'is denied access' do
      get base_path, { event_id: event.id }, auth_header_for(user)

      expect(response.status).to eq 403
    end
  end

  context 'show' do
    it 'is denied access' do
      object = create(factory_name, event: event)
      get "#{base_path}/#{object.id}", { event_id: event.id }, auth_header_for(user)

      expect(response.status).to eq 403
    end
  end

  context 'create' do
    it 'is denied access' do
      post(base_path,
           { event_id: event.id }.merge(
             jsonapi_params(type,
                            attributes: attributes_for(factory_name),
                         relationships: { relationship_name => event })
           ),
           auth_header_for(user))

      expect(response.status).to eq 403
    end
  end

  context 'update' do
    it 'is denied access' do
      object = create(factory_name, event: event)

      put("#{base_path}/#{object.id}",
          { event_id: event.id }.merge(
            jsonapi_params(type,
                           id: object.id,
                   attributes: attributes_for(factory_name))
          ),
          auth_header_for(user))

      expect(response.status).to eq 403
    end
  end

  context 'destroy' do
    it 'is denied access' do
      object = create(factory_name, event: event)
      delete "#{base_path}/#{object.id}", { event_id: event.id }, auth_header_for(user)

      expect(response.status).to eq 403
    end
  end
end
