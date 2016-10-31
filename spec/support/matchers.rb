require 'rspec/expectations'

def to_formatted_date(time)
  time.utc.to_formatted_s(:rfc822)
end
RSpec::Matchers.define :be_the_same_time_as do |expected|
  formatted_expected = to_formatted_date(expected)

  match do |actual|
    formatted_actual = to_formatted_date(actual)

    expect(formatted_actual).to eq(formatted_expected)
  end

  failure_message do |actual|
    formatted_actual = to_formatted_date(actual)

    "expected #{formatted_actual} to equal #{formatted_expected}" +
      RSpec::Support::Differ.new.diff(formatted_actual, formatted_expected)
  end

  diffable
end
