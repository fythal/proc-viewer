json.array!(@boards) do |board|
  json.extract! board, :name, :code
  json.url board_url(board, format: :json)
end
