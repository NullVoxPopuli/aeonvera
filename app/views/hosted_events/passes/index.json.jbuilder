json.array!(@passes) do |pass|
  json.extract! pass, :id
  json.url pass_url(pass, format: :json)
end
