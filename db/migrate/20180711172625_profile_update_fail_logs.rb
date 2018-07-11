class ProfileUpdateFailLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_update_fail_logs do |t|
      t.integer :user_id, default: nil, null: false
      t.string :error_message, default: nil, null: false

      t.timestamps null: false
    end
  end
end
