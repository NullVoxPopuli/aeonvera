json.array!(@pricing_tiers) do |pricing_tier|
  json.extract! pricing_tier, 
  json.url pricing_tier_url(pricing_tier, format: :json)
end
