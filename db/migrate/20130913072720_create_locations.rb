class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :ann_id
      t.integer :panel_id
      t.string :location

      t.timestamps
    end
  end
end
