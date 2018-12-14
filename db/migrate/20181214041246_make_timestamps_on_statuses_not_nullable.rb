class MakeTimestampsOnStatusesNotNullable < ActiveRecord::Migration[5.0]
  def up
    change_column_null :statuses, :created_at, false
    change_column_null :statuses, :updated_at, false
  end

  def down
  end
end
