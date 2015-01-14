class AddColumnToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :status_id_str_reversed, :integer, :limit => 8
  end
end
