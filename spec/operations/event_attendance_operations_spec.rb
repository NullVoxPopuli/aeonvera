require 'spec_helper'


describe EventAttendanceOperations::Create do
  let(:klass){ EventAttendanceOperations::Create }
  let(:user){ create(:user) }
  let(:event){ create(:event) }
  let(:package){ create(:package, event: event) }
  let(:level){ create(:level, event: event) }

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

  # This is only for the parameter mapping
  let(:controller){ Api::EventAttendancesController.new }

  it 'creates an attendance' do
    allow(controller).to receive(:params){ params_with_provision }
    params_for_action = controller.send(:create_event_attendance_params)

    operation = klass.new(user, params_with_provision, params_for_action)
    expect{
      operation.run
    }.to change(EventAttendance, :count).by(1)
  end

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

  it 'creates custom_field_responses' do

  end

  it 'assigns the current user as the attendee' do

  end

  it 'sets the attendee' do

  end
end
