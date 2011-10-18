class CreateMakeups < ActiveRecord::Migration
  def self.up
    create_table :makeups do |t|
      t.integer :vital
      t.integer :food
      t.integer :ingredient

      t.timestamps
    end
  end

  def self.down
    drop_table :makeups
  end
end
