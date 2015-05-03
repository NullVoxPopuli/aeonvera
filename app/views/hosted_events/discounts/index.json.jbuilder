json.array!(@discounts) do |discount|
  json.extract! discount, 
  json.url discount_url(discount, format: :json)
end
