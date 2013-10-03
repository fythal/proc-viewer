class AddBoardIdToPanel < ActiveRecord::Migration
  def change
    change_table(:panels) do |t|
      t.integer :panel_id
    end
  end
end
