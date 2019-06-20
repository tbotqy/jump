# frozen_string_literal: true

class ChangePkFromIntToBigintOnTweetImportJobProgresses < ActiveRecord::Migration[5.2]
  def up
    change_column :tweet_import_job_progresses, :id, :bigint, auto_increment: true
  end

  def down
    change_column :tweet_import_job_progresses, :id, :int, auto_increment: true
  end
end
