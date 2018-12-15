class AddTimestampsToStatuses < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :statuses, null: false, default: -> { 'NOW()' }
  end
end
