class AlterColumnNameToNumberForPanelTable < ActiveRecord::Migration
  def change
    rename_column :panels, :name, :number
  end
end
