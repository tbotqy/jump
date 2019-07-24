class RemovePercentageDenominatorFromTweetImportProgresses < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweet_import_progresses, :percentage_denominator, :integer, null: false, after: :count
  end
end
