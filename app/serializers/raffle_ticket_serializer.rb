class RaffleTicketSerializer < ActiveModel::Serializer
  type 'raffle-ticket'
  attributes :id, :name, :number_of_tickets, :current_price, :price

  belongs_to :raffle

end
