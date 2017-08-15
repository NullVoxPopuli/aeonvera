# frozen_string_literal: true

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

RSpec::Matchers.define :have_used_serializer do |klass, resource|
  match do |response_body|
    expected = ActiveModelSerializers::SerializableResource.new(resource, {
                                                                  serializer: klass
                                                                }).serializable_hash.to_json

    expect(response_body).to eq expected
  end
end

RSpec::Matchers.define :have_relation_to do |expected_ar_instance, options = {}|
  relation_name = options[:relation]
  resource_type = options[:type]

  resource_type ||= expected_ar_instance.class.name.underscore.dasherize.pluralize
  relation_name ||= resource_type.singularize

  expected_type = resource_type
  expected_id = expected_ar_instance.id

  match do |json|
    relation = json.dig('data', 'relationships', relation_name, 'data')

    raise "relation not found: #{relation_name}" unless relation

    expect(relation['type']).to eq(expected_type)
    expect(relation['id'].to_s).to eq(expected_id.to_s)
  end

  failure_message do |json|
    relation = json.dig('data', 'relationships', relation_name, 'data')

    raise "relation not found: #{relation_name}" unless relation

    actual_type = relation['type']
    actual_id = relation['id']

    "expected id and type of #{expected_id} and #{expected_type}, but received #{actual_id} and #{actual_type}"
  end
end

RSpec::Matchers.define :have_attribute do |attribute_name, value = :__not_used|
  check_value = value != :__not_used

  match do |json|
    attribute = json.dig('data', 'attributes', attribute_name)
    exists = expect(attribute).to be_present

    return expect(attribute).to eq value if check_value
    return exists
  end

  failure_message do |json|
    attribute = json.dig('data', 'attributes', attribute_name)

    return "expected #{attribute_name} to be present" unless attribute
    return "expected #{attribute_name} to have a value of #{value}, but was #{attribute}" if check_value

    "#{attribute_name} exists, but has a value of #{attribute}"
  end
end
