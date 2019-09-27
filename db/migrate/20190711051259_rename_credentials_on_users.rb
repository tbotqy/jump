class RenameCredentialsOnUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :token,        :access_token
    rename_column :users, :token_secret, :access_token_secret
  end
end
