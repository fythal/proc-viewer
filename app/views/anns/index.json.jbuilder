json.array!(@anns) do |ann|
  json.extract! ann, :name, :pdf
  json.url ann_url(ann, format: :json)
end
