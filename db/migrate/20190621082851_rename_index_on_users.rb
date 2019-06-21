# frozen_string_literal: true

class RenameIndexOnUsers < ActiveRecord::Migration[5.2]
  def change
    rename_index :users, :idx_ti_on_users, :index_users_on_twitter_id
  end
end
