json.array!(@panels) do |panel|
  json.extract! panel, :name
  json.url panel_url(panel, format: :json)
end
