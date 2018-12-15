class ChangeDefaultValueForTimestampsOnStatuses < ActiveRecord::Migration[5.0]
  def change
    change_column_default :statuses, :created_at, nil
    change_column_default :statuses, :updated_at, nil
  end
end
