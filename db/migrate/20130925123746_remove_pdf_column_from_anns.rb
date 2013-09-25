class RemovePdfColumnFromAnns < ActiveRecord::Migration
  def change
    remove_column :anns, :pdf
  end
end
