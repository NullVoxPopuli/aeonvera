# frozen_string_literal: true

module Api
  module Events
    class RegistrationSerializableResource < Users::RegistrationSerializableResource
      type 'events/registrations'

      attributes :deleted_at,
                 :transferred_to_email,
                 :transferred_from_first_name, :transferred_from_last_name,
                 :transferred_at,
                 :transferred_to_year
    end
  end
end
