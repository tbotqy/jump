# frozen_string_literal: true

class RemoveManuallyNamedIndexForUserIdOnStatuses < ActiveRecord::Migration[5.2]
  def up
    remove_index :statuses, name: :idx_u_on_statuses
  end

  def down
    add_index :statuses, :user_id, name: :idx_u_on_statuses
  end
end
