class RaffleSerializer < ActiveModel::Serializer

  attributes :id, :name, :winner, :winner_has_been_chosen

  belongs_to :event
  has_many :raffle_tickets, serializer: RaffleTicketSerializer
  # see: models/raffle_ticket_purchaser.rb (not AR model)
  has_many :ticket_purchasers, serializer: RaffleTicketPurchaserSerializer

  def ticket_purchasers
    return @ticket_purchase_data if @ticket_purchase_data
    by_attendance_id = {}
    # need attendance_id, name, number_of_tickets_purchased (see serializer)
    object.ticket_purchases.includes(:line_item, order: { attendance: :attendee } ).map do |order_line_item|
      id = order_line_item.order.attendance_id
      ticket = order_line_item.line_item
      attendance = order_line_item.order.attendance
      next unless attendance && ticket

      by_attendance_id[id] ||= RaffleTicketPurchaser.new(id, attendance.attendee_name)
      old_number_purchased = by_attendance_id[id].number_of_tickets_purchased
      by_attendance_id[id].number_of_tickets_purchased = old_number_purchased + ticket.number_of_tickets
    end
    @ticket_purchase_data = by_attendance_id.values
  end

  def winner
    if object.winner.present?
      object.winner.attendee_name
    end
  end

  def winner_has_been_chosen
    object.winner.present?
  end

end
