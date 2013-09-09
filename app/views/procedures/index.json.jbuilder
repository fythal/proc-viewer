json.array!(@procedures) do |procedure|
  json.extract! procedure, :path, :ann_id, :revision, :revised_on, :prev_revision_id
  json.url procedure_url(procedure, format: :json)
end
