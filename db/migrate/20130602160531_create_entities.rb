class CreateEntities < ActiveRecord::Migration
  def change
    create_table "entities", :force => true do |t|
      t.integer "status_id",              :limit => 8, :null => false
      t.integer "status_id_str",          :limit => 8, :null => false
      t.string  "url"
      t.string  "display_url"
      t.string  "hashtag"
      t.string  "mention_to_screen_name"
      t.integer "mention_to_user_id_str", :limit => 8
      t.integer "indice_f",                            :null => false
      t.integer "indice_l",                            :null => false
      t.string  "type",                                :null => false
      t.integer "created",                             :null => false
    end
  end
end
