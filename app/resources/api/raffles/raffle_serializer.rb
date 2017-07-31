# frozen_string_literal: true
module Api
  class RaffleSerializer < ActiveModel::Serializer
    attributes :id, :name, :winner, :winner_has_been_chosen

    belongs_to :event
    has_many :raffle_tickets, serializer: RaffleTicketSerializer
    # see: models/raffle_ticket_purchaser.rb (not AR model)
    has_many :ticket_purchasers, serializer: RaffleTicketPurchaserSerializer

    def ticket_purchasers
      return @ticket_purchase_data if @ticket_purchase_data
      by_registration_id = {}
      # need registration_id, name, number_of_tickets_purchased (see serializer)
      object.ticket_purchases.includes(:line_item, order: { registration: :attendee }).map do |order_line_item|
        id = order_line_item.order.registration_id
        ticket = order_line_item.line_item
        registration = order_line_item.order.registration
        next unless registration && ticket

        by_registration_id[id] ||= RaffleTicketPurchaser.new(id, registration.attendee_name)
        old_number_purchased = by_registration_id[id].number_of_tickets_purchased
        by_registration_id[id].number_of_tickets_purchased = old_number_purchased + ticket.number_of_tickets
      end
      @ticket_purchase_data = by_registration_id.values
    end

    def winner
      object.winner.attendee_name if object.winner.present?
    end

    def winner_has_been_chosen
      object.winner.present?
    end
  end
end
