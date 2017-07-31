# frozen_string_literal: true
module Api
  class RaffleTicketSerializer < ActiveModel::Serializer
    type 'raffle_ticket'
    attributes :id, :name, :number_of_tickets, :current_price, :price

    belongs_to :raffle
  end
end
