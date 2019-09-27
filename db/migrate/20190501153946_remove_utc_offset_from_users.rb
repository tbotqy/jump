# frozen_string_literal: true

class RemoveUtcOffsetFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :utc_offset, :integer
  end
end
