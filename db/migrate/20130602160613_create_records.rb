class CreateRecords < ActiveRecord::Migration
  def change
    create_table "records", :force => true do |t|
      t.integer "status_id",   :limit => 8, :null => false
      t.string  "status_text"
      t.boolean "done",                     :null => false
      t.integer "done_at"
    end
  end
end
