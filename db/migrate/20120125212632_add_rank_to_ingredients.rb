class AddRankToIngredients < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :rank, :integer
  end

  def self.down
    remove_column :ingredients, :rank
  end
end
