class AddXAndYColumnsToLocationsTable < ActiveRecord::Migration
  def change
    change_table(:locations) do |t|
      t.integer :x, :y
    end
  end
end
