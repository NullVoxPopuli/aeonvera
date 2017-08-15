# frozen_string_literal: true

# == Schema Information
#
# Table name: raffles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  event_id   :integer
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#  winner_id  :integer
#

require 'rails_helper'

describe Raffle do
  describe '#choose_winner!' do
    before(:each) do
      @event = create(:event)
      raffle = create(:raffle, event: @event)
      raffle_ticket = create(:raffle_ticket, raffle: raffle, host: @event)
      @registration = create(:registration, host: @event)
      order = create(:order, host: @event, registration: @registration)
      create(:order_line_item, line_item: raffle_ticket, order: order)

      raffle.reload
      @raffle = raffle
    end

    it 'chooses a winner' do
      expect(@raffle.winner).to be_nil
      @raffle.choose_winner!
      expect(@raffle.winner).to eq @registration
    end
  end
end
