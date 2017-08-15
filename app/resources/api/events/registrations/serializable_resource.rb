# frozen_string_literal: true

module Api
  module Events
    class RegistrationSerializableResource < Users::RegistrationSerializableResource
      type 'events/registrations'
    end
  end
end
