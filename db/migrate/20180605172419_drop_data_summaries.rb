class DropDataSummaries < ActiveRecord::Migration[5.0]
  def up
    drop_table :data_summaries
  end

  def down
  end
end
