class RemovePrevRevisionIdFromProcedures < ActiveRecord::Migration
  def change
    remove_column :procedures, :prev_revision_id
  end
end
