# frozen_string_literal: true

class AddIndexToUserIdOnStatusesForFk < ActiveRecord::Migration[5.2]
  def change
    add_index :statuses, :user_id
  end
end
