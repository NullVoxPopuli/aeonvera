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

RSpec::Matchers.define :have_relation_to do |expected_ar_instance, relation_name = nil|
  resource_type = expected_ar_instance.class.name.underscore.dasherize.pluralize
  relation_name ||= resource_type.singularize

  expected_type = resource_type
  expected_id = expected_ar_instance.id

  match do |response|
    json = JSON.parse(response.body)
    relation = json.dig('data', 'relationships', relation_name, 'data')

    raise "relation not found: #{relation_name}" unless relation

    expect(relation['type']).to eq(expected_type)
    expect(relation['id'].to_s).to eq(expected_id.to_s)
  end

  failure_message do |actual|
    json = JSON.parse(response.body)
    relation = json.dig('data', 'relationships', relation_name, 'data')

    raise "relation not found: #{relation_name}" unless relation

    actual_type = relation['type']
    actual_id = relation['id']

    "expected id and type of #{expected_id} and #{expected_type}, but received #{actual_id} and #{actual_type}"
  end
end
