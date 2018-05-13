class ChangeColumnInitializedFlagToFinishedInitialImportOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :initialized_flag, :finished_initial_import
  end
end
