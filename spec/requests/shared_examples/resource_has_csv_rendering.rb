# frozen_string_literal: true

require 'rails_helper'

shared_examples 'resource_has_csv_rendering' do |options = {}|
  factory_name = options[:factory]
  base_path = options[:base_path]
  relationship_name = options[:parent_relationship_name]
  type = options[:type]
  actions = options[:actions]

  let(:owner) { create_confirmed_user }
  let(:event) { create(:event, hosted_by: owner) }

  context 'index' do
    let!(:object) { create(factory_name, relationship_name => event) }

    it 'succeeds' do
      get(
        "#{base_path}.csv",
        {
          event_id: event.id,
          fields: object.attributes.keys.join(',')
        },
        auth_header_for(owner)
      )

      expect(response.status).to eq 200
    end
  end
end
