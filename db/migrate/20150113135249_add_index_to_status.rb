class AddIndexToStatus < ActiveRecord::Migration
  def change
    add_index :statuses, [:user_id,:status_id_str], :name => "idx_uid_sidstr"
    add_index :statuses, [:user_id,:twitter_created_at,:status_id_str], :name => "idx_uid_tcat_sidstr"
    add_index :statuses, [:twitter_created_at,:status_id_str], :name => "idx_tcat_sidstr"
    add_index :statuses, [:status_id_str], :name => "idx_sidstr"
  end
end
