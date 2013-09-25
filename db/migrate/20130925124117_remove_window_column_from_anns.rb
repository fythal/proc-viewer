class RemoveWindowColumnFromAnns < ActiveRecord::Migration
  def change
    remove_column :anns, :window
  end
end
