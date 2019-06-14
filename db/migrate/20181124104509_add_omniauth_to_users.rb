# frozen_string_literal: true

class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string, null: false, after: :twitter_id
    add_column :users, :uid, :string, null: false, after: :id
  end
end
