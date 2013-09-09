class AddPanelAndWindowToAnn < ActiveRecord::Migration
  def change
    add_column :anns, :panel, :string
    add_column :anns, :window, :string
  end
end
