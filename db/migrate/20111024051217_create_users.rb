class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :username
      t.string :hash
      t.text :password
      t.integer :worker
      t.integer :warnings
      t.integer :online_orders
      t.integer :ban
      t.integer :activated
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
