module PanelsHelper
  def num_to_alpha(index)
    index = index.to_i
    (1..8).include?(index) ? index.to_s.tr('1-8', 'A-H') : ""
  end
end
