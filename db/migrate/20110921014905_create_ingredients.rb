class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.integer :id
      t.string :ingredient_name
      t.integer :amount_in_stock
      t.string :unit_of_stock

      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients
  end
end
