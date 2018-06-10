class AddProtectedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :protected, :boolean, null: false, default: false, after: :screen_name
  end
end
