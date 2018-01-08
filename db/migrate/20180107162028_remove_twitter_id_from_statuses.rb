class RemoveTwitterIdFromStatuses < ActiveRecord::Migration
  def up
    remove_column :statuses, :twitter_id
  end
end
