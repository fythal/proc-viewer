class ChangeColumnNamePanelIdToBoardIdInPanelsTable < ActiveRecord::Migration
  def change
    change_table(:panels) do |t|
      t.rename :panel_id, :board_id
    end
  end
end
