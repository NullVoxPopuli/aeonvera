require 'rails_helper'

RSpec.describe Api::EventAttendancesController, type: :controller do
  before(:each) do
    login_through_api
    @event = create(:event, hosted_by: @user)
  end

  context 'index' do
    it 'is a list of all attendances' do
      get :index, event_id: @event.id
    end

    it 'is a list of all cancelled attendances' do
      get :index, event_id: @event.id, cancelled: true
    end
  end

  context 'show' do
    it 'returns a single attendance' do
      @cancelled = create(:attendance,
                          host: @event,
                          level: create(:level),
                          package: create(:package),
                          attendee: @user,
                          attending: false)

      get :show, id: @cancelled.id
    end

    it 'returns a non-cancelled attendance' do
      @non_cancelled = create(:attendance,
                          host: @event,
                          level: create(:level),
                          package: create(:package),
                          attendee: @user,
                          attending: true)

      get :show, id: @non_cancelled.id
    end
  end
end
