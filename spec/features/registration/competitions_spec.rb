require 'spec_helper'


describe 'Registration Competitions' do

  before(:each) do
    login_as_confirmed_user
    Event.destroy_all
    @event = create(:event, hosted_by: @user)
    @opening_tier = @event.opening_tier
    @opening_tier.date = Time.now - 1.day
    @opening_tier.save

    @c1 = create(:competition, event: @event, kind: Competition::SOLO_JAZZ)
    @c2 = create(:competition, event: @event, kind: Competition::STRICTLY)
    @c3 = create(:competition, event: @event, kind: Competition::JACK_AND_JILL)

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

    # somehow select the competition

    submit_form

    expect(page).to_not have_content(@c1.name)
  end

  it 'strictly requires a partner name' do

  end

  it 'decides to not compete' do
    # select competitions

    submit_form

    visit @event.url + "/register#{Attendance.last.id}/edit"

    submit_form

    # deselect
    expect(page).to_not have_content(@c1.name)
    expect(page).to_not have_content(@c2.name)
    expect(page).to_not have_content(@c3.name)
  end

  it 'changes the orientation' do
    # select competitions

    submit_form

    visit @event.url + "/register#{Attendance.last.id}/edit"

    submit_form

    expect(page).to have_content(Attendance::LEAD)
  end




end
