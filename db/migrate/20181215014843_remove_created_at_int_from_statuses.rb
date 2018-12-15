class RemoveCreatedAtIntFromStatuses < ActiveRecord::Migration[5.0]
  def up
    remove_column :statuses, :created_at_int
  end

  def down
  end
end
