class AddThresholdColumnToIngredients < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :threshold, :integer
  end

  def self.down
    remove_column :ingredients, :threshold
  end
end
