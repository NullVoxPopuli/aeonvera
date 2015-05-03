json.array!(@packages) do |package|
  json.extract! package, 
  json.url package_url(package, format: :json)
end
