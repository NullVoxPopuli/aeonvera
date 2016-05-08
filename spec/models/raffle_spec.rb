require 'rails_helper'

describe Raffle do

  describe '#choose_winner!' do
    before(:each) do
      @event = create(:event)
      raffle = create(:raffle, event: @event)
      raffle_ticket = create(:raffle_ticket, raffle: raffle, host: @event)
      @attendance = create(:attendance, host: @event)
      order = create(:order, host: @event, attendance: @attendance)
      create(:order_line_item, line_item: raffle_ticket, order: order)

      raffle.reload
      @raffle = raffle
    end

    it 'chooses a winner' do
      expect(@raffle.winner).to be_nil
      @raffle.choose_winner!
      expect(@raffle.winner).to eq @attendance
    end
  end
end
