def json_api_create_with(klass, params)
  params = ActiveModelSerializers::KeyTransform.dash(params)

  expect { post :create, params }.to change(klass, :count).by(1)

  json = JSON.parse(response.body)
  data = json['data']
  attributes = data['attributes']
  return yield(json, attributes) if block_given?

  # auto compare attributes
  given_attributes = params[:data][:attributes]
  given_attributes.each do |key, value|
    actual = attributes[key.to_s]
    # output all this if there is no match :-(
    if actual != value
      puts key
      puts value
      puts attributes
      puts attributes[key]
    end

    expect(actual).to eq value
  end
end

def json_api_update_with(obj, params)
  params = ActiveModelSerializers::KeyTransform.dash(params)
  patch :update, { id: obj.id }.merge(params)

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
