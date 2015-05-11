FactoryGirl.define do

  sequence :email do |n|
    "email#{n}@factory.com"
  end

  sequence :address do |n|
    {

    }
  end

  sequence :domain do |n|
    "domain#{n}"
  end

  factory :user do
    first_name "ÆONVERA"
    last_name "User Test"
    email
    password "12345678"
    password_confirmation "12345678"
  end

  factory :event do
    name "Test Event"
    domain
    short_description "An event created with FactoryGirl"
    starts_at { 6.months.from_now }
    ends_at { 6.months.from_now + 3.days }
    housing_status Event::HOUSING_ENABLED
    has_volunteers true
    association :hosted_by, factory: :user
    payment_email "test@test.com"
    location "Indianapolis, IN"
    show_on_public_calendar true
    opening_tier
    # association :opening_tier, factory: opening_tier, strategy: :build
  end

  factory :level do
    name "Level Number something"
  end


  factory :organization do
    name "Naptown Stomp"
    tagline "Vintage Dancing. Modern Fun"
    city "Indianapolis"
    state "Indiana"
    domain
  end

  factory :collaboration do

  end

  factory :custom_field do
    label "A field "
    kind CustomField::KIND_TEXT
  end

  factory :dance, class: LineItem::Dance do
    name "A Dance!"
  end

  factory :lesson, class: LineItem::Lesson do
    name "A Lesson!"
    description "description"
    price 10
    starts_at 2.days.from_now
    ends_at 3.days.from_now
    registration_opens_at 1.days.from_now
    registration_closes_at 2.days.from_now
  end

  factory :membership_option, class: LineItem::MembershipOption do
    name "Yearly Membership"
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
    name "My Discount"
    value 5
  end

  factory :package do
    name "Dance Only"
    initial_price 50
    at_the_door_price 80
    requires_track false
    event
  end

  factory :competition do
    name "Jack and Jill"
    kind Competition::JACK_AND_JILL
  end

  factory :discount do
    name "My Discount"
    value 5
  end

  factory :pricing_tier do
    event
    date Date.tomorrow
    increase_by_dollars 10
  end

  factory :opening_tier, class: PricingTier do
    date Date.tomorrow
  end

  factory :order do
    metadata { {} }
  end

  factory :order_line_item do

  end

  factory :attendance, class: EventAttendance do
    association :host, factory: :event
    attendee
    pricing_tier
    package
    metadata {
      {
        "address" => {
          "line1" => "1234 stree",
          "city" => "City",
          "state" => "IN",
          "zip" => "46204"
        }
      }
    }

    after(:build) do |attendance, evaluator|
      attendance.dance_orientation = 0
    end
  end

  factory :attendee, class: User do
    first_name "Attendee"
    last_name "Test"
    email
    password "12345678"
    password_confirmation "12345678"
  end

  factory :shirt, class: LineItem::Shirt do
    event
    name "Test Shirt"
    price 15
    metadata {
      {
        "sizes" => ['XS', 'S', 'SM', 'M', 'L', 'XL', 'XXL', 'XXXL']
      }
    }
  end

end
