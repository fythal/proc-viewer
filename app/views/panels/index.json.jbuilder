json.array!(@panels) do |panel|
  json.extract! panel, :number
  json.url panel_url(panel, format: :json)
end
