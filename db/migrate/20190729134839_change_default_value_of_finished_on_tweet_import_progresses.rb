class ChangeDefaultValueOfFinishedOnTweetImportProgresses < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:tweet_import_progresses, :finished, from: 0, to: nil)
  end
end
