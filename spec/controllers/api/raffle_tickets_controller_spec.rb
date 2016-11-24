require 'rails_helper'

RSpec.describe Api::RaffleTicketsController, type: :controller do
  before(:each) do
    login_through_api
    @event = create(:event, hosted_by: @user)
    @raffle = create(:raffle, event: @event)
  end

  context 'show' do
    before(:each) do
      @ticket_option = create(
        :raffle_ticket,
        host: @event,
        raffle: @raffle,
        metadata: {'number_of_tickets' => 1})
    end

    it 'renders with the raffle ticket serializer' do
      get :show, id: @ticket_option.id, raffle_id: @raffle.id
      json = JSON.parse(response.body)
      result = ActiveModelSerializers::SerializableResource.new(
        @ticket_option,
        serializer: Api::RaffleTicketSerializer,
        adapter: :json_api).serializable_hash.as_json

      expect(json).to eq result
    end
  end

end
