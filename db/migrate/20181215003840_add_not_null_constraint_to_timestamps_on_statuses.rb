class AddNotNullConstraintToTimestampsOnStatuses < ActiveRecord::Migration[5.0]
  def change
    change_column_null :statuses, :created_at, false
    change_column_null :statuses, :updated_at, false
  end
end
