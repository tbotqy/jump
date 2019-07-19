class RemoveFinishedFromTweetImportProgresses < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweet_import_progresses, :finished, :boolean, null: false, after: :percentage_denominator
  end
end
