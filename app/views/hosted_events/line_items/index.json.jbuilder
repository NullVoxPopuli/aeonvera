json.array!(@line_items) do |line_item|
  json.extract! line_item, 
  json.url level_url(line_item, format: :json)
end
