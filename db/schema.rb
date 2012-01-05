# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema
#definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the
#more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111226102206) do

 create_table "ingredients", :force => true do |t|
   t.string   "ingredient_name"
   t.integer  "amount_in_stock"
   t.string   "unit_of_stock"
   t.datetime "created_at"
   t.datetime "updated_at"
   t.integer  "threshold"
 end

 create_table "makeups", :force => true do |t|
   t.integer  "vital"
   t.integer  "food"
   t.integer  "ingredient"
   t.datetime "created_at"
   t.datetime "updated_at"
 end

 create_table "menus", :force => true do |t|
   t.string "item_name"
   t.string "parent_name"
 end

 create_table "orders", :force => true do |t|
   t.string   "name"
   t.integer  "user_id"
   t.string   "order"
   t.integer  "started"
   t.integer  "finished"
   t.datetime "created_at"
   t.datetime "updated_at"
   t.string   "notes"
 end

 create_table "parents", :force => true do |t|
   t.string   "parent_name"
   t.string   "class_of_food"
   t.integer  "rgb"
   t.datetime "created_at"
   t.datetime "updated_at"
 end

 create_table "users", :force => true do |t|
   t.string  "name"
   t.string  "email"
   t.string  "username"
   t.string  "hash"
   t.text    "password"
   t.integer "worker"
   t.integer "warnings"
   t.integer "online_orders"
   t.integer "ban"
   t.integer "activated"
   t.integer "year"
   t.integer "phone_number"
   t.integer "contact_options"
   t.string  "phone_number1"
 end

end