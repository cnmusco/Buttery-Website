class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :id
      t.string :user_name
      t.string :email_address
      t.string :pwd
      t.integer :banned

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
