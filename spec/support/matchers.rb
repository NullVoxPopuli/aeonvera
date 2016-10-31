require 'rspec/expectations'

RSpec::Matchers.define :be_the_same_time_as do |expected|
  match do |actual|
    actual.utc.to_i == expected.utc.to_i
  end
end
