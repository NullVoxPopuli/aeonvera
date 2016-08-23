# frozen_string_literal: true
require 'spec_helper'

describe Attendance do
  describe 'associations' do
    describe 'custom_field_responses' do
      it 'destroys when the attendance is destroyed' do
        a = create(:attendance)
        create(:custom_field_response, writer: a)

        expect do
          a.destroy
        end.to change(CustomFieldResponse, :count).by -1
      end
    end

    describe 'order_line_items' do
      it 'has an order_line_item' do
        attendance = Attendance.new
        attendance.save(validate: false)
        order = Order.new(attendance: attendance)
        order.save(validate: false)
        order_line_item = OrderLineItem.new(order: order)
        order_line_item.save(validate: false)

        attendance.reload
        expect(attendance.order_line_items).to include(order_line_item)
      end
    end

    describe 'raffle_tickets' do
      it 'has raffle tickets' do
        raffle_ticket = LineItem::RaffleTicket.new
        raffle_ticket.save(validate: false)
        attendance = Attendance.new
        attendance.save(validate: false)
        order = Order.new(attendance: attendance)
        order.save(validate: false)
        order_line_item = OrderLineItem.new(order: order, line_item_id: raffle_ticket.id, line_item_type: raffle_ticket.class.name)
        order_line_item.save(validate: false)

        attendance.reload
        expect(attendance.raffle_tickets).to include(raffle_ticket)
      end
    end
  end

  describe '#attendee_name' do
    let(:event) { create(:event) }

    it 'returns the transfer name if set' do
      attendance = create(:attendance, event: event, transferred_to_name: 'Luke')

      expect(attendance.attendee_name).to eq 'Luke'
    end

    it 'returns the name of the user' do
      user = create(:user)
      attendance = create(:attendance, event: event, attendee: user)

      expect(attendance.attendee_name).to eq user.name.titleize
    end
  end
end
