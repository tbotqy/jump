class RefineTimestampsOnStatuses < ActiveRecord::Migration[5.0]
  def up
    remove_column :statuses, :created_at
    add_timestamps :statuses, null: true
  end

  def down
  end
end
