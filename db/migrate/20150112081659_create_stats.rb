class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :type
      t.integer :value, :limit => 8
      t.integer :updated_at
    end
  end
end
