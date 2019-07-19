class RenameTweetImportJobProgressesToTweetImportProgresses < ActiveRecord::Migration[5.2]
  def change
    rename_table :tweet_import_job_progresses, :tweet_import_progresses
  end
end
