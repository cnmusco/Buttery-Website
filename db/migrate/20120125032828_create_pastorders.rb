class CreatePastorders < ActiveRecord::Migration
  def self.up
    create_table :pastorders do |t|
      t.string :name
      t.integer :user_id
      t.string :order
      t.string :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :pastorders
  end
end
