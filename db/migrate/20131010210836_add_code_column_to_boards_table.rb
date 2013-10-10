class AddCodeColumnToBoardsTable < ActiveRecord::Migration
  def change
    change_table(:boards) do |t|
      t.string :code
    end
  end
end
