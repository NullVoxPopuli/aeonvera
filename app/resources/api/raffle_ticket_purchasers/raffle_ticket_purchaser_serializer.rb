# frozen_string_literal: true
module Api
  # the objects for this is built in raffle#ticket_purchase_data
  class RaffleTicketPurchaserSerializer < ActiveModel::Serializer
    attributes :id, :registration_id, :name, :number_of_tickets_purchased

    def id
      object.registration_id
    end

    def registration_id
      object.registration_id
    end

    def name
      object.name
    end

    def number_of_tickets_purchased
      object.number_of_tickets_purchased
    end
  end
end
