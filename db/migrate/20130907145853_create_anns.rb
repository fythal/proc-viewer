class CreateAnns < ActiveRecord::Migration
  def change
    create_table :anns do |t|
      t.string :name
      t.string :pdf

      t.timestamps
    end
  end
end
