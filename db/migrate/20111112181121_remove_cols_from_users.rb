class RemoveColsFromUsers < ActiveRecord::Migration
  def self.up
      remove_column :users, :created_at
      remove_column :users, :updated_at
  end

  def self.down
  end
end
