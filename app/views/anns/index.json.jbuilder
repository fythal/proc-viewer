json.array!(@anns) do |ann|
  json.extract! ann, :id, :name, :panel_number, :panel_location
  json.url ann_url(ann, format: :json)
end
