class CreateParents < ActiveRecord::Migration
  def self.up
    create_table :parents do |t|
      t.string :parent_name
      t.string :class_of_food
      t.integer :rgb

      t.timestamps
    end
  end

  def self.down
    drop_table :parents
  end
end
