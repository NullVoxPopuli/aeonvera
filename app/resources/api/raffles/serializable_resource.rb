# frozen_string_literal: true

module Api
  class RaffleSerializableResource < ApplicationResource
    type 'raffles'

    attributes :name

    attribute(:winner_has_been_chosen) { @object.winner.present? }

    attribute(:winner) do
      @object.winner.attendee_name if @object.winner.present?
    end

    belongs_to :event, class: '::Api::EventSerializableResource'
    has_many :raffle_tickets, class: '::Api::RaffleTicketSerializableResource'
    # see: models/raffle_ticket_purchaser.rb (not AR model)
    has_many :ticket_purchasers, class: '::Api::RaffleTicketPurchaserSerializableResource' do
      data do
        next @ticket_purchase_data if @ticket_purchase_data

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
    end
  end
end
