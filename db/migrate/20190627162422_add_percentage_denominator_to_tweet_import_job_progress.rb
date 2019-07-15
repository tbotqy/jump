class AddPercentageDenominatorToTweetImportJobProgress < ActiveRecord::Migration[5.2]
  def up
    add_column :tweet_import_job_progresses, :percentage_denominator, :integer, null: true, after: :count
    fill_existing_records!
    change_column_null :tweet_import_job_progresses, :percentage_denominator, false
  end

  def down
    remove_column :tweet_import_job_progresses, :percentage_denominator
  end

  def fill_existing_records!
    TweetImportJobProgress.all.each do |record|
      record.update!(percentage_denominator: [record.count, 3200].min)
    end
  end
end
