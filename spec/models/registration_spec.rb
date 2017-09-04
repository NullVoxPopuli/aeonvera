# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
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
#  registration_type            :string(255)
#  transferred_to_name        :string
#  transferred_to_user_id     :integer
#  transferred_at             :datetime
#  transfer_reason            :string
#
# Indexes
#
#  index_registrations_on_attendee_id                                (attendee_id)
#  index_registrations_on_host_id_and_host_type                      (host_id,host_type)
#  index_registrations_on_host_id_and_host_type_and_registration_type  (host_id,host_type,registration_type)
#

require 'spec_helper'

describe Registration do
  describe 'associations' do
    describe 'custom_field_responses' do
      it 'destroys when the registration is destroyed' do
        a = create(:registration)
        create(:custom_field_response, writer: a)

        expect do
          a.destroy
        end.to change(CustomFieldResponse, :count).by -1
      end
    end

    describe 'order_line_items' do
      it 'has an order_line_item' do
        registration = create(:registration)
        order = create(:order, registration: registration, host: registration.event)
        order_line_item = create(:order_line_item,
                                 order: order,
                                 line_item: create(:line_item, host: registration.event))

        registration.reload
        expect(registration.order_line_items).to include(order_line_item)
      end
    end

    describe 'raffle_tickets' do
      it 'has raffle tickets' do
        raffle_ticket = LineItem::RaffleTicket.new
        raffle_ticket.save(validate: false)
        registration = Registration.new
        registration.save(validate: false)
        order = Order.new(registration: registration)
        order.save(validate: false)
        order_line_item = OrderLineItem.new(order: order, line_item_id: raffle_ticket.id, line_item_type: raffle_ticket.class.name)
        order_line_item.save(validate: false)

        registration.reload
        expect(registration.raffle_tickets).to include(raffle_ticket)
      end
    end
  end

  context 'lifecycle' do
    let(:registration) { create(:registration) }

    describe 'before_destroy' do
      describe '#ensure_unpaid' do
        context 'order is paid' do
          let!(:order) { create(:order, paid: true, registration: registration) }

          it 'cannot be deleted' do
            expect { registration.destroy }
              .to change(registration.errors, :count).by 1
          end

          it 'adds a message to the errors' do
            registration.destroy

            error = registration.errors.full_messages.first
            expect(error).to match(/cannot delete/)
          end
        end

        context 'order is upnaid' do
          let!(:order) { create(:order, paid: false, registration: registration) }

          it 'can be deleted' do
            expect { registration.destroy }
              .to change(Registration, :count).by(-1)
          end
        end
      end
    end
  end

  describe '#attendee_name' do
    let(:event) { create(:event) }

    it 'returns the individual names if set' do
      registration = create(:registration,
                            event: event,
                            attendee_first_name: 'Luke',
                            attendee_last_name: 'Skywalker')

      expect(registration.attendee_name).to eq 'Luke Skywalker'
    end

    it 'returns the name of the user' do
      user = create(:user)
      registration = create(:registration,
                            event: event, attendee: user,
                            attendee_first_name: '',
                            attendee_last_name: '')

      expect(registration.attendee_name).to eq user.name.titleize
    end
  end
end
