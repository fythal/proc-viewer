class AddNameColumnToPanels < ActiveRecord::Migration
  def change
    change_table(:panels) do |t|
      t.string :name
    end
  end
end
