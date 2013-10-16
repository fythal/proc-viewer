json.array!(@panels) do |panel|
  json.extract! panel, :number, :height, :width
  json.url panel_url(panel, format: :json)
end
