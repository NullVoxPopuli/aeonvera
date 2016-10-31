class RaffleTicket < LineItem::RaffleTicket
  class << self
    def sti_name
      LineItem::RaffleTicket.name
    end
  end
end
