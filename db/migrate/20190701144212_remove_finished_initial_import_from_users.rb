class RemoveFinishedInitialImportFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :finished_initial_import, :boolean, default: :false, null: false, after: :token_secret
  end
end
