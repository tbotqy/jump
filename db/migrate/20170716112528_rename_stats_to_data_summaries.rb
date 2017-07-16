class RenameStatsToDataSummaries < ActiveRecord::Migration
  def change
    rename_table :stats, :data_summaries
  end
end
