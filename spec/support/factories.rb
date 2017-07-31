# frozen_string_literal: true
FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  sequence :address do |_n|
    {

    }
  end

  sequence :domain do |n|
    "domain#{n}"
  end

  factory :user do
    first_name 'ÆONVERA'
    last_name 'User Test'
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :hosted_by, class: User do
    first_name 'Hosted'
    last_name 'User Test'
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :opening_tier, class: PricingTier do
    date Date.tomorrow
    increase_by_dollars 0
    event
  end

  factory :event do
    name 'Test Event'
    domain
    short_description 'An event created with FactoryGirl'
    starts_at { 6.months.from_now }
    ends_at { 6.months.from_now + 3.days }
    housing_status Event::HOUSING_ENABLED
    has_volunteers true
    payment_email 'test@test.com'
    location 'Indianapolis, IN'
    show_on_public_calendar true
    hosted_by

    # opening_tier
    after(:build) do |e|
      # e.hosted_by = create(:hosted_by) unless e.hosted_by
      e.opening_tier = create(:opening_tier, event: e) unless e.opening_tier.present?
    end

    factory :sponsored do
    end
  end

  factory :note do
    note 'some notes and stuff'
    author factory: :user
    target factory: :user
  end

  factory :raffle do
    name 'Some Test Raffle'
    event
  end

  factory :raffle_ticket, class: LineItem::RaffleTicket do
    name '1 Ticket'
    number_of_tickets 1
    current_price 5
    raffle
    host factory: :event
  end

  factory :housing_request do
    preferred_gender_to_house_with 'Guys'
    need_transportation false
    can_provide_transportation true
    transportation_capacity 3
    allergic_to_pets true
    allergic_to_smoke true
    other_allergies 'pollen'
    notes 'Some Notes'
  end

  factory :housing_provision do
    housing_capacity 10
    number_of_showers 2
    can_provide_transportation true
    preferred_gender_to_host 'Eeither'
    has_pets false
    smokes false
    notes 'Some Notes'
  end

  factory :level do
    name 'Level Number something'
  end

  factory :organization do
    name 'Naptown Stomp'
    tagline 'Vintage Dancing. Modern Fun'
    city 'Indianapolis'
    state 'Indiana'
    domain

    factory :sponsor do
    end
  end

  factory :sponsorship do
    sponsor
    sponsored
    discount
  end

  factory :collaboration do
  end

  factory :custom_field do
    label 'A field '
    kind CustomField::KIND_TEXT
    host factory: :event
    user
  end

  factory :custom_field_response do
    value nil
    custom_field
    writer factory: :user
  end

  factory :dance, class: LineItem::Dance do
    name 'A Dance!'
  end

  factory :lesson, class: LineItem::Lesson do
    name 'A Lesson!'
    description 'description'
    price 10
    starts_at 2.days.from_now
    ends_at 3.days.from_now
    registration_opens_at 1.days.from_now
    registration_closes_at 2.days.from_now
  end

  factory :line_item, class: LineItem do
    name 'A line item'
  end

  factory :membership_option, class: LineItem::MembershipOption do
    name 'Yearly Membership'
    duration_unit Duration::DURATION_YEAR
    duration_amount 1
    price 25
  end

  factory :membership_renewal do
    start_date 1.month.ago
    user
    membership_option
  end

  factory :membership_discount do
    name 'My Discount'
    value 5
  end

  factory :package do
    name 'Dance Only'
    initial_price 50
    at_the_door_price 80
    requires_track false
    event
  end

  factory :competition do
    name 'Jack and Jill'
    kind Competition::JACK_AND_JILL
    initial_price 10
    at_the_door_price 10
  end

  factory :discount do
    name 'My Discount'
    value 5
  end

  factory :restraint do
    dependable Discount.new
    restrictable Package.new
  end

  factory :pricing_tier do
    event
    date Date.tomorrow
    increase_by_dollars 10
  end

  factory :order do
    metadata { {} }
    event
    user
  end

  factory :order_line_item do
    order
  end

  factory :registration do
    host factory: :event
    # event
    attendee
    pricing_tier
    package
    attendee_first_name 'First'
    attendee_last_name 'Last'
    dance_orientation Registration::LEAD
    city 'Indianapolis'
    state 'IN'
    metadata do
      {
        'address' => {
          'line1' => '1234 stree',
          'city' => 'City',
          'state' => 'IN',
          'zip' => '46204'
        }
      }
    end

    after(:build) do |registration, _evaluator|
      registration.event = registration.host
      # registration.host = create(:event, hosted_by: registration.attendee) unless registration.host.present?
      registration.dance_orientation = 0
    end
  end

  factory :attendee, class: User do
    first_name 'Attendee'
    last_name 'Test'
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :shirt, class: LineItem::Shirt do
    event
    name 'Test Shirt'
    price 15
    metadata do
      {
        'sizes' => %w(XS S SM M L XL XXL XXXL)
      }
    end
  end
end
