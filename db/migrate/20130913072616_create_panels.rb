class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.string :name

      t.timestamps
    end
  end
end
