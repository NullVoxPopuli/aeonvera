json.array!(@competitions) do |competition|
  json.extract! competition, 
  json.url competition_url(competition, format: :json)
end
