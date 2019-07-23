class ReAddFinishedToTweetImportProgresses < ActiveRecord::Migration[5.2]
  def change
    add_column :tweet_import_progresses, :finished, :boolean, null: false, default: false, after: :percentage_denominator
  end
end
