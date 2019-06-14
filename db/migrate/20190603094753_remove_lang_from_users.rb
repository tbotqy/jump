# frozen_string_literal: true

class RemoveLangFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :lang, :string
  end
end
