json.array!(@shirts) do |shirt|
  json.extract! shirt, 
  json.url shirt_url(shirt, format: :json)
end
