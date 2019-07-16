class MakeDirectUrlOnMediaNullable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :media, :direct_url, true
  end
end
