class RemoveJobIdFromTweetImportProgresses < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweet_import_progresses, :job_id, :string, limit: 36, null: false, after: :id
  end
end
