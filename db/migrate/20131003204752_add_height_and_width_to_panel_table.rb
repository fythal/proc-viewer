class AddHeightAndWidthToPanelTable < ActiveRecord::Migration
  def change
    change_table(:panels) do |t|
      t.integer :height, :width
    end
  end
end
