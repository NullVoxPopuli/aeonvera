# frozen_string_literal: true

module Api
  module RegistrationForms
    class Create < Reform::Form
      property :attendee_first_name
      property :attendee_last_name
      property :phone_number
      property :interested_in_volunteering
      property :city
      property :state

      validation do
        configure do
          option :form
          config.messages_file = 'config/locales/validations.yml'

          def require_phone_number?(value)
            return false unless form['interested_in_volunteering']
            value.present?
          end
        end

        required(:attendee_first_name).filled
        required(:attendee_last_name).filled
        required(:city).filled
        required(:state).filled

        optional(:phone_number).filled(:require_phone_number?)
      end
    end
  end
end
