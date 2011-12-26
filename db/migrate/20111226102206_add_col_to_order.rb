class AddColToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :notes, :string
  end

  def self.down
    remove_column :orders, :notes
  end
end
