# frozen_string_literal: true
module Api
  class VolunteerSerializableResource < ApplicationResource
    type 'volunteers'

    attributes :attendee_name, :attendee_email,
               :amount_owed, :amount_paid, :registered_at,
               :checked_in_at,
               :phone_number

    attribute(:phone_number) { object.metadata['phone_number'] }
    attribute(:amount_paid) { object.paid_amount }
  end
end
