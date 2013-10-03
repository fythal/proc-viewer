class ChangeWidthAndHeightAsHiddenInPanelsTable < ActiveRecord::Migration
  def change
    change_table(:panels) do |t|
      t.rename :height, :_height
      t.rename :width, :_width
    end
  end
end
