class AddPercentageDenominatorToTweetImportJobProgress < ActiveRecord::Migration[5.2]
  def change
    add_column :tweet_import_job_progresses, :percentage_denominator, :integer, null: false, after: :count
  end
end
