# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::UpcomingEventsController, type: :controller do
  before(:each) do
    allow(controller).to receive(:current_user) { nil }
    Event.destroy_all
    @event = create(:event)
  end

  context 'index' do
    it 'does not require authentication' do
      get :index

      body = response.body
      json = JSON.parse(body)
      data = json['data']
      expect(data.count).to eq 1
    end
  end
end
