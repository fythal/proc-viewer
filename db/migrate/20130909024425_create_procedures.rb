class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string :path
      t.integer :ann_id
      t.integer :revision
      t.string :revised_on
      t.integer :prev_revision_id

      t.timestamps
    end
  end
end
