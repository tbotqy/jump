# frozen_string_literal: true

class RenameReservedWordsOnColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :users,    :protected, :protected_flag
    rename_column :statuses, :private,   :private_flag
  end
end
