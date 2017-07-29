require 'rails_helper'

RSpec.describe Api::EventsController, type: :controller do

      context '#revenue' do
        before(:each) do
          pending 'not implemented'
          fail
          @event = create(:event, hosted_by: @user)

          @registration = create(:registration, host: @event)
          @order = create(:order, registration: @registration, event: @event, paid: true)
          allow_any_instance_of(Order).to receive(:net_received){ 10 }
        end

        it 'attending registration is included in total' do

          get :revenue, id: @event.id
          registrations = assigns(:registrations)
          expect(registrations).to include(@registration)

          expect(assigns(:total)).to eq 10
        end

        it 'non-attending registration is not included in total' do
          @registration.destroy
          @registration.save

          get :revenue, id: @event.id
          registrations = assigns(:registrations)
          expect(registrations).to_not include(@registration)

          expect(assigns(:total)).to eq 0
        end

        it 'does not include unpaind, non-attending orders in unpaid revenue' do
          registration = create(:registration, event: @event)
          order = create(:order, registration: registration, event: @event)

          # make not attending
          registration.destroy
          registration.save

          get :revenue, id: @event.id
          expect(assigns(:owed)).to eq 0
          # verify that the total didn't also increase
          expect(assigns(:total)).to eq 10
        end

      end



end
