class ChangeTypeOfRevisedOnColumnOnProcedures < ActiveRecord::Migration
  def up
    change_column(:procedures, :revised_on, :datetime)
  end

  def down
    change_column(:procedures, :revised_on, :string)
  end
end
