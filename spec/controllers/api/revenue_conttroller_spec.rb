require 'rails_helper'

RSpec.describe Api::EventsController, type: :controller do

      context '#revenue' do
        before(:each) do
          pending 'not implemented'
          fail
          @event = create(:event, hosted_by: @user)

          @attendance = create(:attendance, host: @event)
          @order = create(:order, attendance: @attendance, event: @event, paid: true)
          allow_any_instance_of(Order).to receive(:net_received){ 10 }
        end

        it 'attending attendance is included in total' do

          get :revenue, id: @event.id
          attendances = assigns(:attendances)
          expect(attendances).to include(@attendance)

          expect(assigns(:total)).to eq 10
        end

        it 'non-attending attendance is not included in total' do
          @attendance.destroy
          @attendance.save

          get :revenue, id: @event.id
          attendances = assigns(:attendances)
          expect(attendances).to_not include(@attendance)

          expect(assigns(:total)).to eq 0
        end

        it 'does not include unpaind, non-attending orders in unpaid revenue' do
          attendance = create(:attendance, event: @event)
          order = create(:order, attendance: attendance, event: @event)

          # make not attending
          attendance.destroy
          attendance.save

          get :revenue, id: @event.id
          expect(assigns(:owed)).to eq 0
          # verify that the total didn't also increase
          expect(assigns(:total)).to eq 10
        end

      end



end
