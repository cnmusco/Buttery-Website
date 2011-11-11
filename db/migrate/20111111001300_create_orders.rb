class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :name
      t.integer :user_id
      t.string :order
      t.integer :started
      t.integer :finished

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
