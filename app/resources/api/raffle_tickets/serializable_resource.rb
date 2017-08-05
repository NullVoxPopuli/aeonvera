# frozen_string_literal: true

module Api
  class RaffleTicketSerializableResource < ApplicationResource
    type 'raffle-tickets'

    attributes :name, :number_of_tickets, :current_price, :price

    belongs_to :raffle, class: '::Api::RaffleSerializableResource'
  end
end
