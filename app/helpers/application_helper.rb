module ApplicationHelper
  def loc_id(x, y)
    y = y.to_s.tr('1-8', 'a-h')
    "loc_#{y}#{x}"
  end
end
