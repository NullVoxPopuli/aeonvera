require 'rspec/expectations'

RSpec::Matchers.define :be_the_same_time_as do |expected|
  match do |actual|
    actual.utc.to_formatted_s(:rfc822) == expected.utc.to_formatted_s(:rfc822)
  end

  diffable
end
