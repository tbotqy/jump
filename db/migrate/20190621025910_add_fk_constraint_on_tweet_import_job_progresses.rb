# frozen_string_literal: true

class AddFkConstraintOnTweetImportJobProgresses < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :tweet_import_job_progresses, :users
  end

  def down
    remove_foreign_key :tweet_import_job_progresses, :users
    remove_index       :tweet_import_job_progresses, :user_id # index for user_id has not been set before this migration
  end
end
