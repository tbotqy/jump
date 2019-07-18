class RemoveClosedOnlyFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :closed_only, :boolean, null: true, default: false, after: :statuses_updated_at
  end
end
