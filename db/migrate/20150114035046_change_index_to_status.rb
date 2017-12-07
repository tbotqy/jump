class ChangeIndexToStatus < ActiveRecord::Migration
  def up
    add_index :statuses, [:user_id,:status_id_str_reversed], :name => "idx_uid_sisr"
    add_index :statuses, [:user_id,:twitter_created_at,:status_id_str_reversed], :name => "idx_uid_tca_sisr"
    add_index :statuses, [:twitter_created_at,:status_id_str_reversed], :name => "idx_tca_sisr"
    add_index :statuses, [:status_id_str_reversed], :name => "idx_sisr"
  end

  def down
  end
end
