# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121219222024) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "sale_id",    :null => false
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["sale_id"], :name => "index_comments_on_sale_id"

  create_table "devices", :force => true do |t|
    t.string   "duid",       :null => false
    t.string   "apns_token"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "faves", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "sale_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "faves", ["sale_id"], :name => "index_faves_on_sale_id"
  add_index "faves", ["user_id"], :name => "index_faves_on_user_id"

  create_table "sales", :force => true do |t|
    t.integer  "user_id",                                               :null => false
    t.string   "store_name",          :limit => 128,                    :null => false
    t.text     "store_url"
    t.string   "brand",               :limit => 128,                    :null => false
    t.string   "product",             :limit => 128,                    :null => false
    t.integer  "category_id",                                           :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.boolean  "has_image_1"
    t.boolean  "has_image_2"
    t.boolean  "has_image_0"
    t.string   "image_0"
    t.string   "image_1"
    t.string   "image_2"
    t.float    "percent_off"
    t.text     "display_address"
    t.string   "size",                :limit => 32
    t.integer  "orig_price_cents",                   :default => 0,     :null => false
    t.string   "orig_price_currency",                :default => "USD", :null => false
    t.integer  "sale_price_cents",                   :default => 0,     :null => false
    t.string   "sale_price_currency",                :default => "USD", :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "comment_count",                      :default => 0
    t.integer  "fave_count",                         :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "email",       :null => false
    t.string   "passwd_hash", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "photo"
  end

end
