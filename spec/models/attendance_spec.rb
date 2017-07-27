# frozen_string_literal: true
# == Schema Information
#
# Table name: attendances
#
#  id                         :integer          not null, primary key
#  attendee_id                :integer
#  host_id                    :integer
#  level_id                   :integer
#  package_id                 :integer
#  pricing_tier_id            :integer
#  interested_in_volunteering :boolean
#  needs_housing              :boolean
#  providing_housing          :boolean
#  metadata                   :text
#  checked_in_at              :datetime
#  deleted_at                 :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#  attending                  :boolean          default(TRUE), not null
#  dance_orientation          :string(255)
#  host_type                  :string(255)
#  attendance_type            :string(255)
#  transferred_to_name        :string
#  transferred_to_user_id     :integer
#  transferred_at             :datetime
#  transfer_reason            :string
#
# Indexes
#
#  index_attendances_on_attendee_id                                (attendee_id)
#  index_attendances_on_host_id_and_host_type                      (host_id,host_type)
#  index_attendances_on_host_id_and_host_type_and_attendance_type  (host_id,host_type,attendance_type)
#

require 'spec_helper'

describe Attendance do
  describe 'associations' do
    describe 'custom_field_responses' do
      it 'destroys when the attendance is destroyed' do
        a = create(:registration)
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
      attendance = create(:registration, event: event, transferred_to_name: 'Luke')

      expect(attendance.attendee_name).to eq 'Luke'
    end

    it 'returns the name of the user' do
      user = create(:user)
      attendance = create(:registration, event: event, attendee: user)

      expect(attendance.attendee_name).to eq user.name.titleize
    end
  end
end
