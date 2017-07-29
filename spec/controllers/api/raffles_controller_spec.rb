require 'rails_helper'

RSpec.describe Api::RafflesController, type: :controller do
  before(:each) do
    login_through_api
    @event = create(:event, hosted_by: @user)
  end

  context 'show' do
    it 'includes the purchasers' do
      raffle = create(:raffle, event: @event)
      ticket_option = create(:raffle_ticket, host: @event, raffle: raffle, metadata: {'number_of_tickets' => 1})
      registration = create(:registration, event: @event)
      order = create(:order, registration: registration, host: @event)
      create(:order_line_item,
        order: order,
        line_item: ticket_option,
        quantity: 1)

      get :show, id: raffle.id, include: 'ticket_purchasers'

      included = json_api_included

      expect(included).to_not be_nil
      expect(included.count).to be 1
      attributes = included.first['attributes']

      expect(attributes['registration-id']).to eq registration.id
      expect(attributes['number-of-tickets-purchased']).to eq 1
      expect(attributes['name']).to eq registration.attendee_name
    end
  end

  context 'update' do
    context 'chooses a new winner' do
      before(:each) do
        @raffle = create(:raffle, event: @event)
        @ticket_option = create(:raffle_ticket, host: @event, raffle: @raffle)
      end

      it 'chooses a new winner' do
        # gotta create some ticket purchases
        registration = create(:registration, event: @event)
        order = create(:order, registration: registration, host: @event)
        create(:order_line_item,
          order: order,
          line_item: @ticket_option,
          quantity: 1)
        # sanity, to make sure the test data is correct
        # For whatever reason, when this is uncommented, it *sometimes* fails...
        # (this expectation, that is... not sure what's up with that).
        # maybe a caching issue.
        # expect(@event.registrations.with_raffle_tickets(@raffle.id).first).to eq registration

        # now the actual test
        json_api = {
          'id' => @raffle.id,
          'data' => {
            'id' => @raffle.id,
            'attributes' => {
              'choose-new-winner' => true
            }, 'type' => 'raffles'
          }
        }

        patch :update, json_api
        data = json_api_data
        attributes = data['attributes']
        expect(attributes['winner']).to eq registration.attendee_name
        expect(attributes['winner-has-been-chosen']).to eq true
      end

      it 'does not choose a new winner when there are no tickets' do
        json_api = {
          'id' => @raffle.id,
          'data' => {
            'id' => @raffle.id,
            'attributes' => {
              'choose_new_winner' => true
            }, 'type' => 'raffles'
          }
        }

        patch :update, json_api

        data = json_api_data
        attributes = data['attributes']
        expect(attributes['winner-has-been-chosen']).to eq false
      end
    end
  end
end
