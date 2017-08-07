# frozen_string_literal: true
def jsonapi_params(type, id: nil, attributes: {}, relationships: {})
  attributes[:id] = id if id

  data = {
    type: type,
    attributes: CaseTransform.dash(attributes),
    relationships: relationships.each_with_object({}) do |(k, v), h|
      h[k] = { data: { type: v.class.name.downcase.pluralize, id: v.try(:id) } }
    end
  }

  data[:id] = id if id

  {
    data: data
  }
end

def json_response
  JSON.parse(response.body)
end

def json_api_data
  json = JSON.parse(response.body)
  data = json['data']
end

def json_api_included
  json = JSON.parse(response.body)
  data = json['included']
end

def json_api_create_with(klass, params)
  params = CaseTransform.dash(params)

  expect do
    post :create, params
    ap JSON.parse(response.body) if response.status != 201
    expect(response.status).to eq 201
  end.to change(klass, :count).by(1)

  json = JSON.parse(response.body)
  data = json['data']
  attributes = data['attributes']
  relationships = data['relationships'] || {}
  return yield(json, attributes) if block_given?

  # auto compare attributes
  given_attributes = params[:data][:attributes]
  given_attributes.each do |key, value|
    actual = attributes[key.to_s]
    # check if actual is a time
    if value.is_a?(Time)
      # removes ms
      value2 = Time.parse(value.to_s)
      actual2 = Time.parse(actual)

      puts value2
      puts actual2
      value = value2.dup
      actual = actual2.dup
      puts value2
      puts actual2
      puts '----'
    end
    # output all this if there is no match :-(
    if actual != value
      puts 'key    :  ' + key.inspect
      puts 'value  :  ' + value.inspect
      puts 'actual :  ' + actual.inspect
      puts attributes
    end

    expect(actual).to eq value
  end

  id = data['id']
  id = attributes['-id'] if data['id'].include?('.')
  created_object = klass.find(id)
  expect(created_object).to be_present

  # auto compare relationships
  given_relationships = params[:data][:relationships]
  given_relationships.each do |relationship_name, reldata|
    relationship_id = reldata[:data][:id].to_s
    relationship_type = reldata[:data][:type]

    # don't check the response relationships if we don't have any
    next unless relationships.present?

    actual_relationship = relationships[relationship_name.to_s]
    # this relationship is not rendered
    next unless actual_relationship

    id = actual_relationship['data']['id'].to_s
    type = actual_relationship['data']['type']

    expect(id).to eq relationship_id
    expect(type).to eq relationship_type

    # check the saved relationships
    # rails_relationship_name = relationship_type.underscore.singularize
    # actual_relationship = created_object.send(rails_relationship_name)
    # # how do we verify a has_many relationship?
    # unless actual_relationship.responds_to?(:each)
    #   expect(actual_relationship.id).to eq relationship_id
    # end
  end
end

def json_api_update_with(obj, params)
  params = CaseTransform.underscore(params)
  patch :update, { id: obj.id }.merge(params)

  # expect(response.status).to eq 200

  json = JSON.parse(response.body)
  data = json['data']
  attributes = data['attributes']
  return yield(json, attributes) if block_given?

  # validate the response
  given_attributes = params[:data][:attributes]
  given_attributes.each do |key, value|
    expect(attributes[key.to_s]).to eq value
  end
end
