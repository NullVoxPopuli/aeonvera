require 'spec_helper'

describe HostedEvents::CancelledAttendancesController do

  before(:each) do
    login
    @event = create(:event, hosted_by: @user)
    @cancelled = create(:attendance,
                        host: @event,
                        level: create(:level),
                        package: create(:package),
                        attendee: @user,
                        attending: false)
  end

  describe '#index' do

    it 'visits' do
      get :index, hosted_event_id: @event.id
    end
  end

  describe 'destroy' do

    it 'destroys' do
      expect{
        delete :destroy, hosted_event_id: @event.id, id: @cancelled
      }.to change(Attendance.where(attending: true), :count).by(1)
    end

    it 'destroys a non existant' do
      expect{
        delete :destroy, hosted_event_id: @event.id, id: @cancelled
      }.to change(Attendance, :count).by(0)
      expect(response).to be_redirect
    end
  end



end
