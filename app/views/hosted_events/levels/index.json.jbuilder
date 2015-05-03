json.array!(@levels) do |level|
  json.extract! level, 
  json.url level_url(level, format: :json)
end
