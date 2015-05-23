require 'spec_helper'


describe 'Registration Competitions' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save

    @package = create(:package, event: @event)

    @c1 = create(:competition, event: @event, kind: Competition::SOLO_JAZZ, name: 'solo')
    @c2 = create(:competition, event: @event, kind: Competition::STRICTLY, name: 'strictly')
    @c3 = create(:competition, event: @event, kind: Competition::JACK_AND_JILL, name: 'jack')

    visit @event.url
    selects_package
    selects_orientation
    provides_address
  end

  it 'selects no competitions' do

    submit_form

    expect(page).to_not have_content(@c1.name)
    expect(page).to_not have_content(@c2.name)
    expect(page).to_not have_content(@c3.name)
  end

  it 'jack and jill requires orientation' do
    check_box_with_id("#attendance_competition_responses_attributes_2__destroy")
    submit_form

    expect(page).to have_content('Please correct ')
    expect(page).to have_content('dance orientation ')
  end

  it 'strictly requires a partner name' do
    check_box_with_id("#attendance_competition_responses_attributes_1__destroy")
    submit_form

    expect(page).to have_content('Please correct ')
    expect(page).to have_content('partner name')
  end

  it 'decides to not compete' do
    pending('capybara appears to not be able to uncheck things')
    # select competitions
    check_box_with_id("#attendance_competition_responses_attributes_0__destroy")
    submit_form
    expect(page).to have_content(@c1.name)
    expect(page).to_not have_content(@c2.name)
    expect(page).to_not have_content(@c3.name)

    visit @event.url + "/register/#{Attendance.last.id}/edit"
    # deselect
    uncheck("attendance_competition_responses_attributes_0__destroy")

    submit_form

    expect(page).to_not have_content(@c1.name)
    expect(page).to_not have_content(@c2.name)
    expect(page).to_not have_content(@c3.name)
  end

  it 'changes the orientation' do
    # pending('capybara appears to not be able to change radio buttons once set')
    # select competitions
    check_box_with_id("#attendance_competition_responses_attributes_2__destroy")
    choose("attendance_competition_responses_attributes_2_dance_orientation_follow")
    submit_form

    expect(page).to_not have_content(@c1.name)
    expect(page).to_not have_content(@c2.name)
    expect(page).to have_content("#{@c3.name}: #{Attendance::FOLLOW}")

    visit @event.url + "/register/#{Attendance.last.id}/edit"

    # competitions swich order, and therefore switch ids
    # because available competitions come after the participating
    # find(:css, "#attendance_competition_responses_attributes_0_dance_orientation_lead", visible: false).click
    choose("attendance_competition_responses_attributes_0_dance_orientation_lead")
    submit_form

    expect(page).to_not have_content(@c1.name)
    expect(page).to_not have_content(@c2.name)
    expect(page).to have_content("#{@c3.name}: #{Attendance::LEAD}")
  end




end
