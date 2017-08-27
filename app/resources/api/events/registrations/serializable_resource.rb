# frozen_string_literal: true

module Api
  module Events
    class RegistrationSerializableResource < Users::RegistrationSerializableResource
      type 'events/registrations'

      attribute :deleted_at
    end
  end
end
