# frozen_string_literal: true

module Api
  class NoteSerializableResource < ApplicationResource
    type 'notes'

    attributes :note
    attribute(:author_name) { @object.author.name }

    belongs_to :host, class: { Event: '::Api::EventSerializableResource',
                               Organization: '::Api::OrganizationSerializableResource' }
    belongs_to :target, class: { User: '::Api::MemberSerializableResource' }
  end
end
