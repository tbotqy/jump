class CreatePublicDates < ActiveRecord::Migration
  def change
    create_table "public_dates", :force => true do |t|
      t.string  "posted_date",     :limit => 10, :null => false
      t.integer "posted_unixtime",               :null => false
    end
    
    add_index "public_dates", ["posted_date"], :name => "posted_date", :unique => true
    add_index "public_dates", ["posted_unixtime"], :name => "posted_unixtime"
  end
end
