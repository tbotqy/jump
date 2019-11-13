class ChangeTypeOfTextToTextOnStatuses < ActiveRecord::Migration[6.0]
  def up
    change_column :statuses, :text, :text
  end

  def down
    change_column :statuses, :text, :string, limit: 280
  end
end
