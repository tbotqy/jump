# frozen_string_literal: true

class RemoveTimeZoneFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :time_zone, :string
  end
end
