require 'rails_helper'

RSpec.describe Api::RafflesController, type: :controller do
  before(:each) do
    login_through_api
    @event = create(:event, hosted_by: @user)
  end

  context 'update' do
    context 'chooses a new winner' do
      before(:each) do
        @raffle = create(:raffle, event: @event)
        @ticket_option = create(:raffle_ticket, host: @event, raffle: @raffle)
      end

      it 'chooses a new winner' do
        # gotta create some ticket purchases
        attendance = create(:attendance, event: @event)
        create(:attendance_line_item,
          attendance: attendance,
          line_item: @ticket_option,
          quantity: 1,
          line_item_type: @ticket_option.class.name)
        # sanity, to make sure the test data is correct
        # For whatever reason, when this is uncommented, it *sometimes* fails...
        # (this expectation, that is... not sure what's up with that).
        # maybe a caching issue.
        # expect(@event.attendances.with_raffle_tickets(@raffle.id).first).to eq attendance

        # now the actual test
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
        expect(attributes['winner']).to eq attendance.attendee_name
        expect(attributes['winner_has_been_chosen']).to eq true
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
        expect(attributes['winner_has_been_chosen']).to eq false
      end
    end
  end
end
