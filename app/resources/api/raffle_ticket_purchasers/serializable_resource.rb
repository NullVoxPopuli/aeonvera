# frozen_string_literal: true

module Api
  # the objects for this is built in raffle#ticket_purchase_data
  class RaffleTicketPurchaserSerializableResource < ApplicationResource
    type 'raffle-ticket-purchasers'

    id { @object.registration_id }

    attribute(:registration_id) { @object.registration_id }
    attribute(:name) { @object.name }
    attribute(:number_of_tickets_purchased) { @object.number_of_tickets_purchased }
  end
end
