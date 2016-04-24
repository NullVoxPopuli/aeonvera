require 'spec_helper'


describe EventAttendanceOperations::Create do
  let(:klass){ EventAttendanceOperations::Create }
  let(:user){ create(:user) }
  let(:event){ create(:event) }
  let(:package){ create(:package, event: event) }

  # This is only for the parameter mapping
  let(:controller){ Api::EventAttendancesController.new }

  context 'bare minimum to register' do

    let(:basic_params){
      {"data"=>{
        "attributes"=>{
          "package-id"=>nil, "amount-owed"=>nil, "amount-paid"=>nil, "checked-in-at"=>nil, "attendee-name"=>nil,
          "dance-orientation"=>"Lead",
          "registered-at"=>nil, "package-name"=>nil, "level-name"=>nil,
          "interested-in-volunteering"=>nil,
          "event-id"=>nil,
          "phone-number"=>nil, "address1"=>nil, "address2"=>nil,
          "city"=>"Fishers", "state"=>"IN", "zip"=>nil},
        "relationships"=>{
          "level"=>{"data"=>nil},
          "package"=>{"data"=>{"type"=>"packages", "id"=>package.id}},
          "attendee"=>{"data"=>nil},
          "pricing-tier"=>{"data"=>nil},
          "host"=>{"data"=>{"type"=>"events", "id"=>event.id}},
          "orders"=>{"data"=>[{"type"=>"orders", "id"=>nil}]},
          "unpaid-order"=>{"data"=>nil},
          "housing-request"=>{},
          "housing-provision"=>{}
        },
        "type"=>"event-attendances"},
      "event_attendance"=>{}}
    }

    it 'creates an attendance' do
      allow(controller).to receive(:params){ basic_params }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, basic_params, params_for_action)
      expect{
        operation.run
      }.to change(EventAttendance, :count).by(1)
    end

    it 'assigns the current user as the attendee' do
      allow(controller).to receive(:params){ basic_params }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, basic_params, params_for_action)
      attendance = operation.run
      expect(attendance.attendee).to eq user
    end

    it 'the event owner sets the attendee' do
      basic_params['data']['relationships']['attendee']['data'] = { 'type' => 'users', 'id' => user.id }
      allow(controller).to receive(:params){ basic_params }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(event.hosted_by, basic_params, params_for_action)
      attendance = operation.run
      expect(attendance.attendee).to eq user
    end

  end

  context 'the attendee wants to provide housing' do
    # must test with real params
    let(:params_with_provision){
      {"data"=>{
        "attributes"=>{
          "package-id"=>nil, "amount-owed"=>nil, "amount-paid"=>nil, "checked-in-at"=>nil, "attendee-name"=>nil,
          "dance-orientation"=>"Lead",
          "registered-at"=>nil, "package-name"=>nil, "level-name"=>nil,
          "interested-in-volunteering"=>nil,
          "event-id"=>nil,
          "phone-number"=>nil, "address1"=>nil, "address2"=>nil,
          "city"=>"Fishers", "state"=>"IN", "zip"=>nil},
        "relationships"=>{
          "level"=>{"data"=>nil},
          "package"=>{"data"=>{"type"=>"packages", "id"=>package.id}},
          "attendee"=>{"data"=>nil},
          "pricing-tier"=>{"data"=>nil},
          "host"=>{"data"=>{"type"=>"events", "id"=>event.id}},
          "orders"=>{"data"=>[{"type"=>"orders", "id"=>nil}]},
          "unpaid-order"=>{"data"=>nil},
          "housing-request"=>{},
          "housing-provision"=>{"data"=>{
            "attributes"=>{"housing-capacity"=>1, "number-of-showers"=>4, "can-provide-transportation"=>false, "transportation-capacity"=>3, "preferred-gender-to-host"=>"Guys", "has-pets"=>true, "smokes"=>true, "notes"=>"aoeu"},
            "relationships"=>{
              "host"=>{"data"=>nil},
              "attendance"=>{"data"=>nil}},
            "type"=>"housing-provisions"}}
        },
        "type"=>"event-attendances"},
      "event_attendance"=>{}}
    }

    it 'creates a housing provision' do
      allow(controller).to receive(:params){ params_with_provision }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, params_with_provision, params_for_action)
      expect{
        operation.run
      }.to change(HousingProvision, :count).by(1)
    end

    it 'populates the housing provision' do
      allow(controller).to receive(:params){ params_with_provision }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, params_with_provision, params_for_action)
      attendance = operation.run
      hp = attendance.housing_provision

      # all of these are non-default values
      expect(hp.housing_capacity).to eq 1
      expect(hp.number_of_showers).to eq 4
      expect(hp.can_provide_transportation).to eq false
      expect(hp.transportation_capacity).to eq 3
      expect(hp.preferred_gender_to_host).to eq 'Guys'
      expect(hp.has_pets).to eq true
      expect(hp.smokes).to eq true
      expect(hp.notes).to eq 'aoeu'
    end

  end

  context 'the attendee wants to request housing' do
    let(:level){ create(:level, event: event) }

    # must test with real params..
    let(:params_with_level_and_request){
      {"data"=>{
        "attributes"=>{
          "package-id"=>nil, "amount-owed"=>nil, "amount-paid"=>nil, "checked-in-at"=>nil, "attendee-name"=>nil,
          "dance-orientation"=>"Lead", "registered-at"=>nil, "package-name"=>nil, "level-name"=>nil,
          "interested-in-volunteering"=>nil, "event-id"=>nil,
          "phone-number"=>nil, "address1"=>nil, "address2"=>nil, "city"=>"Fishers", "state"=>"IN", "zip"=>nil},
        "relationships"=>{
          "level"=>{"data"=>{"type"=>"levels", "id"=>level.id}},
          "package"=>{"data"=>{"type"=>"packages", "id"=>package.id}},
          "attendee"=>{"data"=>nil}, "pricing-tier"=>{"data"=>nil},
          "host"=>{"data"=>{"type"=>"events", "id"=>event.id}},
          "orders"=>{"data"=>[{"type"=>"orders", "id"=>nil}]},
          "unpaid-order"=>{"data"=>nil},
          "housing-request"=>{"data"=>{
            "attributes"=>{
              "need-transportation"=>true, "can-provide-transportation"=>true, "transportation-capacity"=>3, "allergic-to-pets"=>true, "allergic-to-smoke"=>true, "other-allergies"=>"Cheese :-(", "preferred-gender-to-house-with"=>"Gals", "notes"=>"Some notes.",
              "requested-roommates" => ["1", "2", "3", "4"],
              "unwanted-roommates" => ["9", "8", "7", "6"]},
            "relationships"=>{
              "host"=>{"data"=>nil},
              "attendance"=>{"data"=>nil},
              "housing-provision"=>{"data"=>nil}},
            "type"=>"housing-requests"}},
          "housing-provision"=>{}},
        "type"=>"event-attendances"},
      "event_attendance"=>{}}
    }


    it 'creates a housing request' do
      allow(controller).to receive(:params){ params_with_level_and_request }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, params_with_level_and_request, params_for_action)
      expect{
        operation.run
      }.to change(HousingRequest, :count).by(1)
    end

    it 'populates the housing request' do
      allow(controller).to receive(:params){ params_with_level_and_request }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, params_with_level_and_request, params_for_action)
      attendance = operation.run
      hr = attendance.housing_request

      # all of these are non-default values
      expect(hr.need_transportation).to eq true
      expect(hr.can_provide_transportation).to eq true
      expect(hr.transportation_capacity).to eq 3
      expect(hr.allergic_to_pets).to eq true
      expect(hr.allergic_to_smoke).to eq true
      expect(hr.other_allergies).to eq 'Cheese :-('
      expect(hr.requested_roommates).to eq ["1", "2", "3", "4"]
      expect(hr.unwanted_roommates).to eq ["9", "8", "7", "6"]
      expect(hr.preferred_gender_to_house_with ).to eq 'Gals'
      expect(hr.notes).to eq 'Some notes.'
    end

  end

  context 'the custom fields have been answered' do
    let(:custom_field1){ create(:custom_field, host: event) }
    let(:custom_field2){ create(:custom_field, host: event) }

    # must test with real params
    let(:params_with_custom_field_responses){
      {"data"=>{
        "attributes"=>{"package-id"=>nil, "amount-owed"=>nil, "amount-paid"=>nil, "checked-in-at"=>nil, "attendee-name"=>nil, "dance-orientation"=>"Lead", "registered-at"=>nil, "package-name"=>nil, "level-name"=>nil, "interested-in-volunteering"=>nil, "event-id"=>nil, "phone-number"=>nil, "address1"=>nil, "address2"=>nil, "city"=>"Fishers", "state"=>"IN", "zip"=>nil},
        "relationships"=>{
          "level"=>{"data"=>nil},
          "package"=>{"data"=>{"type"=>"packages", "id"=>package.id}},
          "attendee"=>{"data"=>nil},
          "pricing-tier"=>{"data"=>nil},
          "host"=>{"data"=>{"type"=>"events", "id"=>event.id}},
          "orders"=>{"data"=>[{"type"=>"orders", "id"=>nil}]},
          "unpaid-order"=>{"data"=>nil},
          "housing-request"=>{},
          "housing-provision"=>{},
          "custom-field-responses"=>{"data"=>[{
              "attributes"=>{"value"=>"50"},
              "relationships"=>{
                "custom-field"=>{"data"=>{"type"=>"custom-fields", "id"=>custom_field1.id}},
                "writer"=>{"data"=>{"type"=>"event-attendances", "id"=>nil}}},
              "type"=>"custom-field-responses"}, {
              "attributes"=>{"value"=>"2016-04-02T16:00:00.000Z"},
              "relationships"=>{
                "custom-field"=>{"data"=>{"type"=>"custom-fields", "id"=>custom_field2.id}},
                "writer"=>{"data"=>{"type"=>"event-attendances", "id"=>nil}}},
              "type"=>"custom-field-responses"}]}},
        "type"=>"event-attendances"},
      "event_attendance"=>{}}
    }

    it 'creates custom_field_responses' do
      allow(controller).to receive(:params){ params_with_custom_field_responses }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, params_with_custom_field_responses, params_for_action)
      expect{
        operation.run
      }.to change(CustomFieldResponse, :count).by(2)
    end

    it 'sets values' do
      allow(controller).to receive(:params){ params_with_custom_field_responses }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, params_with_custom_field_responses, params_for_action)
      attendance = operation.run

      responses = attendance.custom_field_responses
      expect(responses.first.value).to eq '50'
      expect(responses.last.value).to eq "2016-04-02T16:00:00.000Z"
    end

    it 'sets the attendance as the writer relationship' do
      allow(controller).to receive(:params){ params_with_custom_field_responses }
      params_for_action = controller.send(:create_event_attendance_params)

      operation = klass.new(user, params_with_custom_field_responses, params_for_action)
      attendance = operation.run

      responses = attendance.custom_field_responses
      expect(responses.first.writer).to eq attendance
      expect(responses.last.writer).to eq attendance
    end

  end


end
