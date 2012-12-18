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

ActiveRecord::Schema.define(:version => 20121218210810) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "sale_id",    :null => false
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "devices", :force => true do |t|
    t.string  "token",                                        :null => false
    t.string  "alias"
    t.integer "badge",                     :default => 0,     :null => false
    t.string  "locale"
    t.string  "language"
    t.string  "timezone",                  :default => "UTC", :null => false
    t.string  "ip_address", :limit => nil
    t.float   "lat"
    t.float   "lng"
    t.string  "tags",       :limit => nil
  end

  add_index "devices", ["alias"], :name => "devices_alias_index"
  add_index "devices", ["lat", "lng"], :name => "devices_lat_lng_index"
  add_index "devices", ["token"], :name => "devices_token_index"
  add_index "devices", ["token"], :name => "devices_token_key", :unique => true

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
  end

  create_table "users", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "email",       :null => false
    t.string   "passwd_hash", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
