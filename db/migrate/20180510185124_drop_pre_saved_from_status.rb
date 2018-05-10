class DropPreSavedFromStatus < ActiveRecord::Migration
  def up
    remove_column :statuses, :pre_saved
  end
end
