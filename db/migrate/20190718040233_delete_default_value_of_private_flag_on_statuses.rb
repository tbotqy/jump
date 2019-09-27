class DeleteDefaultValueOfPrivateFlagOnStatuses < ActiveRecord::Migration[5.2]
  def up
    change_column_default(:statuses, :private_flag, nil)
  end

  def down
    change_column_default(:statuses, :private_flag, 0)
  end
end
