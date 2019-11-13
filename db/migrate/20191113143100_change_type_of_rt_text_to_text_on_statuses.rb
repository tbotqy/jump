class ChangeTypeOfRtTextToTextOnStatuses < ActiveRecord::Migration[6.0]
  def up
    change_column :statuses, :rt_text, :text
  end

  def down
    change_column :statuses, :rt_text, :string, limit: 280
  end
end
