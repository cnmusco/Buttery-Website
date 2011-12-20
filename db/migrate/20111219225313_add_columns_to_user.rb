class AddColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :phone_number1, :string
  end

  def self.down
    remove_column :users, :phone_number1
  end
end
