# require 'rails_helper'
#
# RSpec.describe Api::EventAttendancesController, type: :controller do
#
#   context 'is not logged in' do
#     it 'requires login to view the current users attendance' do
#       event = create(:event)
#       attendance = create(:registration,
#                           host: event,
#                           level: create(:level),
#                           package: create(:package),
#                           attendee: create(:user),
#                           attending: true)
#
#       get :show, id: attendance.id, current_user: true, event_id: event.id
#       expect(response.status).to eq 401
#     end
#   end
#
#   context 'is logged in' do
#     before(:each) do
#       login_through_api
#       @event = create(:event, hosted_by: @user)
#     end
#
#     context 'index' do
#       it 'is a list of all attendances' do
#         get :index, event_id: @event.id
#       end
#
#       it 'is a list of all cancelled attendances' do
#         get :index, event_id: @event.id, cancelled: true
#       end
#     end
#
#     context 'show' do
#       it 'returns a single attendance' do
#         @cancelled = create(:registration,
#                             host: @event,
#                             level: create(:level),
#                             package: create(:package),
#                             attendee: @user,
#                             attending: false)
#
#         get :show, id: @cancelled.id
#       end
#
#       it 'returns a non-cancelled attendance' do
#         @non_cancelled = create(:registration,
#                             host: @event,
#                             level: create(:level),
#                             package: create(:package),
#                             attendee: @user,
#                             attending: true)
#
#         get :show, id: @non_cancelled.id
#       end
#     end
#   end
#
# end
