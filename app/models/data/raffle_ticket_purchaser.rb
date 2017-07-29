# This model is only used for the raffle serializer
class RaffleTicketPurchaser < ActiveModelSerializers::Model
  attr_accessor :id, :registration_id, :name, :number_of_tickets_purchased

  def initialize(id, name)
    self.registration_id = id
    self.name = name
    self.number_of_tickets_purchased = 0
  end
end
