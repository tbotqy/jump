# frozen_string_literal: true

class ChangeTypeOfUserIdToBigintOnTweetImportJobProgresses < ActiveRecord::Migration[5.2]
  def up
    change_column :tweet_import_job_progresses, :user_id, :bigint
  end

  def down
    change_column :tweet_import_job_progresses, :user_id, :int
  end
end
