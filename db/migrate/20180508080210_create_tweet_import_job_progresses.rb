class CreateTweetImportJobProgresses < ActiveRecord::Migration
  def change
    create_table :tweet_import_job_progresses do |t|
      t.string :job_id, limit: 36, default: nil, null: false
      t.integer :user_id, default: nil, null: false
      t.integer :count, default: 0, null: false
      t.boolean :finished, default: false, null: false

      t.timestamps null: false
    end
  end
end
