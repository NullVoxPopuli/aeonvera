require 'spec_helper'

describe RegisterController do
  before(:each) do
    login
    @event = create(:event)
    @package = create(:package, event: @event)

    # event opened yesterday
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save
  end



  context 'housing request' do

    it 'is assigned to the event' do
      post :create, event_id: @event.id, attendance: {
        package_id: @package.id,
        dance_orientation: "LEAD",
        needs_housing: true,
        housing_request_attributes: build(:housing_request).attributes,
        metadata: {
          address: {
            city: "Indianapolis",
            state: "IN",
            zip: "46204"
          }
        }
      }

      expect(HousingRequest.last.host).to eq @event
    end

    it 'is associated with the attendance' do
      post :create, event_id: @event.id, attendance: {
        package_id: @package.id,
        dance_orientation: "LEAD",
        needs_housing: true,
        housing_request_attributes: build(:housing_request).attributes,
        metadata: {
          address: {
            city: "Indianapolis",
            state: "IN",
            zip: "46204"
          }
        }
      }

      expect(HousingRequest.last.attendance).to eq @event.attendances.last
    end

    it 'does not create a housing request' do
      # Note taht the housing request parameters values are ommitted
      post :create, event_id: @event.id, attendance: {
        package_id: @package.id,
        dance_orientation: "LEAD",
        housing_request_attributes: {},
        metadata: {
          address: {
            city: "Indianapolis",
            state: "IN",
            zip: "46204"
          }
        }
      }

      expect(@event.attendances.last.housing_request).to be_nil
    end

    it 'does not create a housing request when the attributes are missing' do
      post :create, event_id: @event.id, attendance: {
        package_id: @package.id,
        dance_orientation: "LEAD",
        needs_housing: true,
        metadata: {
          address: {
            city: "Indianapolis",
            state: "IN",
            zip: "46204"
          }
        }
      }

      expect(@event.attendances.last.housing_request).to be_nil

    end
  end

  context 'housing provision' do
    it 'is assigned to the event' do
      post :create, event_id: @event.id, attendance: {
        package_id: @package.id,
        dance_orientation: "LEAD",
        providing_housing: true,
        housing_provision_attributes: build(:housing_provision).attributes,
        metadata: {
          address: {
            city: "Indianapolis",
            state: "IN",
            zip: "46204"
          }
        }
      }

      expect(HousingProvision.last.host).to eq @event
    end

    it 'is associated with the attendance' do
      post :create, event_id: @event.id, attendance: {
        package_id: @package.id,
        dance_orientation: "LEAD",
        providing_housing: true,
        housing_provision_attributes: build(:housing_provision).attributes,
        metadata: {
          address: {
            city: "Indianapolis",
            state: "IN",
            zip: "46204"
          }
        }
      }

      expect(HousingProvision.last.attendance).to eq @event.attendances.last
    end

    it 'does not create a housing provision' do
      # Note taht the housing request parameters values are ommitted
      post :create, event_id: @event.id, attendance: {
        package_id: @package.id,
        dance_orientation: "LEAD",
        housing_provision_attributes: {},
        metadata: {
          address: {
            city: "Indianapolis",
            state: "IN",
            zip: "46204"
          }
        }
      }

      expect(@event.attendances.last.housing_provision).to be_nil
    end

    it 'does not create a housing provision when the attributes are missing' do
      post :create, event_id: @event.id, attendance: {
        package_id: @package.id,
        dance_orientation: "LEAD",
        providing_housing: true,
        metadata: {
          address: {
            city: "Indianapolis",
            state: "IN",
            zip: "46204"
          }
        }
      }

      expect(@event.attendances.last.housing_provision).to be_nil

    end

  end

  context 'registration is not open' do

  end

  context 'registration is closed' do

  end

  context 'validation errors' do

  end

  context 'shirts' do

  end

  context 'discounts' do

  end

  context 'contact information' do

  end

  context 'volunteering' do

  end
end
