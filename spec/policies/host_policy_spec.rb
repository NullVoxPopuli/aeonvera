require 'spec_helper'

describe Api::HostPolicy do
  it 'is an organization' do
    policy = Api::HostPolicy.new(User.new, Organization.new)

    expect(policy.read?).to eq true
  end

  it 'is an event' do
    event = Event.new
    event.ends_at = 1.minute.from_now
    policy = Api::HostPolicy.new(User.new, event)

    expect(policy.read?).to eq true
  end

  it 'is a past event' do
    event = Event.new
    event.ends_at = 1.minute.ago
    policy = Api::HostPolicy.new(User.new, event)

    expect(policy.read?).to eq false
  end
end
