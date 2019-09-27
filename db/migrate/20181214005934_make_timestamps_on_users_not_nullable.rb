# frozen_string_literal: true

class MakeTimestampsOnUsersNotNullable < ActiveRecord::Migration[5.0]
  def up
    change_column_null :users, :created_at, false
    change_column_null :users, :updated_at, false
  end
  def down
  end
end
