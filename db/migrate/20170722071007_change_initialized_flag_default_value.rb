class ChangeInitializedFlagDefaultValue < ActiveRecord::Migration
  def change
    change_column_default(:users, :initialized_flag, 0)
  end
end
