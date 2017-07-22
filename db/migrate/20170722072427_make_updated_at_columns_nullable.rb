class MakeUpdatedAtColumnsNullable < ActiveRecord::Migration
  def change
    target_columns = [:token_updated_at, :statuses_updated_at, :friends_updated_at]
    target_columns.each do |target_column|
      change_column_null(:users, target_column, true)
    end
  end
end
