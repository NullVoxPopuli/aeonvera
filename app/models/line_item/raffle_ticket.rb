class LineItem::RaffleTicket < LineItem
  belongs_to :raffle, foreign_key: :reference_id

  def number_of_tickets
    metadata['number_of_tickets']
  end

  def number_of_tickets=(tickets)
    metadata['number_of_tickets'] = tickets
  end
end
