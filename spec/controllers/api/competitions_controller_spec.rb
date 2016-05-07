require 'rails_helper'

RSpec.describe Api::CompetitionsController, type: :controller do

  context 'not logged in' do
    context 'index' do
      it 'renders - nothing private about the competition list' do
        get :index
        expect(response.status).to eq 200
      end
    end

    context 'show' do
      it 'renders an error' do
        get :show, id: 'whatever'
        expect(response.status).to eq 401
      end
    end
  end

  context 'logged in and the owner of the event' do
    let(:event) { create(:event) }
    before(:each) do
      login_through_api(event.hosted_by)
      @competition = create(:competition, event: event)
    end

    context 'index' do
      it 'succeeds' do
        get :index, event_id: event.id
        expect(response.status).to eq 200
      end
    end

    context 'show' do
      it 'succeeds' do
        get :show, id: @competition.id
        expect(response.status).to eq 200
      end
    end

    context 'update' do
      it 'updates the initial_price' do
        new_price = @competition.initial_price + 10
        json_api = {
          id: @competition.id,
          data: {
            type: 'competitions',
            id: @competition.id,
            attributes: { initial_price: new_price.to_s }
          }
        }

        json_api_update_with(@competition, json_api)
        expect(Competition.find(@competition.id).initial_price).to eq new_price
      end
    end

    context 'create' do
      before(:each) do
        @event = create(:event)
        login_through_api(@event.hosted_by)
      end

      it 'creates a new competition' do
        json_api = {
          data: {
            type: 'competitions',
            attributes: {
              initial_price: '9.0',
              name: 'new comp',
              kind: 1,
              at_the_door_price: '10.0'
            },
            relationships: {
              event: {
                data: {
                  id: @event.id,
                  type: 'events'
                }
              }
            }
          }
        }

        json_api_create_with(Competition, json_api)
      end
    end
  end

end
