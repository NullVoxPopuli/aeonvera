# frozen_string_literal: true

module Api
  module Events
    # TODO: remove this file
    require "#{Rails.root}/app/resources/api/users/registrations/serializer"
    # require "#{Rails.root}/app/resources/api/events/registrations/serializer"

    class RegistrationSerializer < Users::RegistrationSerializer
      type 'events/registrations'
    end
  end
end
