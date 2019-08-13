class ExtendLimitOfStatusesRtText < ActiveRecord::Migration[5.2]
  def up
    change_column :statuses, :rt_text, :string, limit: 280, null: true
  end

  def down
    change_column :statuses, :rt_text, :string, limit: 255, null: true
  end
end
