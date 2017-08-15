# frozen_string_literal: true

module Api
  class CollaborationSerializableResource < ApplicationResource
    type 'collaborations'

    attributes :email,
               :user_name, :title, :created_at

    attribute(:user_name) { @object.user&.name }
    attribute(:email) { @object.user&.email }

    belongs_to :host, class: {
      Event: '::Api::EventSerializableResource',
      Organization: '::Api::OrganizationSerializableResource'
    } do
      data do
        @object.collaborated
      end
    end
  end
end
