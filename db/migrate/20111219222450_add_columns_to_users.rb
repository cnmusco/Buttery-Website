class AddColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phone_number, :integer
    add_column :users, :contact_options, :integer
  end

  def self.down
    remove_column :users, :contact_options
    remove_column :users, :phone_number
  end
end
