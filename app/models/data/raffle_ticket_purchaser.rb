# This model is only used for the raffle serializer
class RaffleTicketPurchaser < ActiveModelSerializers::Model
  attr_accessor :id, :attendance_id, :name, :number_of_tickets_purchased

  def initialize(id, name)
    self.attendance_id = id
    self.name = name
    self.number_of_tickets_purchased = 0
  end
end
