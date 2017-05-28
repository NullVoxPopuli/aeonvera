# == Schema Information
#
# Table name: raffles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  event_id   :integer
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#  winner_id  :integer
#

class Raffle < ApplicationRecord
  include SoftDeletable
  belongs_to :event

  has_many :raffle_tickets,
           class_name: LineItem::RaffleTicket.name,
           foreign_key: 'reference_id'

  has_many :tickets,
           class_name: LineItem::RaffleTicket.name,
           foreign_key: 'reference_id'

  # order line items
  has_many :ticket_purchases,
           class_name: OrderLineItem.name,
           through: :raffle_tickets,
           source: :order_line_items

  has_many :ticket_purchasers,
           class_name: Attendance.name,
           through: :raffle_tickets,
           source: :purchasers

  belongs_to :winner,
             class_name: 'Attendance'

  def choose_winner
    build_participant_weights.sample
  end

  def choose_winner!
    self.winner = choose_winner
    save
  end

  def ticket_holders
    event.attendances.participating_in_raffle(id)
  end

  # @return [Array<OrderLineItem>]
  def purchased_tickets
    raffle_tickets
      .includes(order_line_items: [:line_item, { order: :attendance }])
      .map(&:order_line_items).flatten
  end

  private

  # it's ok to return a array with objects in it, because we
  # are not going to store the result of this
  #
  # @return [Array<Attendance>]
  def build_participant_weights
    result = []

    purchased_tickets.each do |order_line_item|
      ticket = order_line_item.line_item
      attendance = order_line_item.order.attendance

      total_tickets = ticket.number_of_tickets * order_line_item.quantity
      total_tickets.times do |_time|
        result << attendance
      end
    end

    result
  end

  # @param [Attendance] ticket_holder
  def tickets_for_ticket_holder(ticket_holder)
    ticket_holder.raffle_tickets.map(&:number_of_tickets).inject(:+)
  end
end
