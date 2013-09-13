class RemovePanelColumnFromAnnTable < ActiveRecord::Migration
  def change
    remove_column :anns, :panel
  end
end
