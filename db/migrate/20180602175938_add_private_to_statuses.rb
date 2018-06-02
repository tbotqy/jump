class AddPrivateToStatuses < ActiveRecord::Migration[5.0]
  def change
    add_column :statuses, :private, :boolean, null: false, default: false, after: :possibly_sensitive
  end
end
