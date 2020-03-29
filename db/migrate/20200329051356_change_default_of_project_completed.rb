class ChangeDefaultOfProjectCompleted < ActiveRecord::Migration[5.1]
  def change
    change_column_default :projects, :completed, false
  end
end
