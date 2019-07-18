class ExtendLimitOfStatusesText < ActiveRecord::Migration[5.2]
  def up
    change_column :statuses, :text, :string, limit: 280, null: false, after: :source
  end

  def down
    change_column :statuses, :text, :string, limit: 255, null: false, after: :source
  end
end
