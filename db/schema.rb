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

ActiveRecord::Schema.define(:version => 20130315035332) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.integer  "sale_id",                   :null => false
    t.integer  "actor_id",                  :null => false
    t.string   "special_key", :limit => 24
    t.text     "message"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "activities", ["special_key"], :name => "index_activities_on_special_key"
  add_index "activities", ["user_id", "created_at"], :name => "index_activities_on_user_id_and_created_at", :order => {"created_at"=>:desc}
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "brands", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "brands", ["name"], :name => "index_brands_on_name"

  create_table "cities", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.float    "lat"
    t.float    "lon"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id",                                     :null => false
    t.integer  "sale_id",                                     :null => false
    t.text     "text"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "created_notifications",    :default => false
    t.datetime "created_notifications_at"
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
    t.integer  "user_id",                                     :null => false
    t.integer  "sale_id",                                     :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "created_notifications",    :default => false
    t.datetime "created_notifications_at"
  end

  add_index "faves", ["created_notifications"], :name => "index_faves_on_created_notifications"
  add_index "faves", ["sale_id"], :name => "index_faves_on_sale_id"
  add_index "faves", ["user_id"], :name => "index_faves_on_user_id"

  create_table "followers", :force => true do |t|
    t.integer  "follower_id",                                 :null => false
    t.integer  "following_id",                                :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "created_notifications",    :default => false
    t.datetime "created_notifications_at"
  end

  add_index "followers", ["created_notifications"], :name => "index_followers_on_created_notifications"

  create_table "leads", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.integer  "device_id",                      :null => false
    t.string   "alert",                          :null => false
    t.string   "sound"
    t.integer  "expiry"
    t.integer  "badge"
    t.text     "custom"
    t.integer  "retries",     :default => 0
    t.boolean  "sent",        :default => false
    t.datetime "sent_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "source_type"
    t.integer  "source_id"
    t.string   "source_key"
  end

  add_index "notifications", ["sent"], :name => "index_notifications_on_sent"

  create_table "pages", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "purchases", :force => true do |t|
    t.integer  "user_id",                                            :null => false
    t.integer  "sale_id",                                            :null => false
    t.string   "status",                                             :null => false
    t.string   "card_last_4",        :limit => 4
    t.string   "external_id"
    t.string   "external_status"
    t.text     "external_message"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.boolean  "sent_initial_email",              :default => false
    t.integer  "subtotal_cents"
    t.integer  "tax_cents"
    t.integer  "shipping_cents"
    t.integer  "total_cents"
    t.string   "address"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "size"
    t.boolean  "ship_it",                         :default => false
    t.string   "retailer_status"
  end

  create_table "sales", :force => true do |t|
    t.integer      "user_id",                                                    :null => false
    t.string       "store_name",               :limit => 128,                    :null => false
    t.text         "store_url"
    t.string       "brand",                    :limit => 128,                    :null => false
    t.string       "product",                  :limit => 128,                    :null => false
    t.integer      "category_id",                                                :null => false
    t.datetime     "created_at",                                                 :null => false
    t.datetime     "updated_at",                                                 :null => false
    t.boolean      "has_image_1"
    t.boolean      "has_image_2"
    t.boolean      "has_image_0"
    t.string       "image_0"
    t.string       "image_1"
    t.string       "image_2"
    t.float        "percent_off"
    t.text         "display_address"
    t.string       "size",                     :limit => 32
    t.integer      "orig_price_cents",                        :default => 0,     :null => false
    t.string       "orig_price_currency",                     :default => "USD", :null => false
    t.integer      "sale_price_cents",                        :default => 0,     :null => false
    t.string       "sale_price_currency",                     :default => "USD", :null => false
    t.float        "latitude"
    t.float        "longitude"
    t.string       "address"
    t.string       "state"
    t.string       "postal_code"
    t.string       "country"
    t.integer      "comment_count",                           :default => 0
    t.integer      "fave_count",                              :default => 0
    t.float        "user_lat"
    t.float        "user_lon"
    t.integer      "city_id"
    t.integer      "store_id"
    t.integer      "brand_id"
    t.string       "city"
    t.boolean      "created_notifications",                   :default => false
    t.datetime     "created_notifications_at"
    t.string       "temp_image_url_0"
    t.string       "temp_image_url_1"
    t.string       "temp_image_url_2"
    t.boolean      "visible",                                 :default => false
    t.boolean      "uploaded_images",                         :default => false
    t.boolean      "processed_images",                        :default => false
    t.boolean      "does_shipping",                           :default => false
    t.boolean      "allow_returns",                           :default => false
    t.boolean      "editors_pick",                            :default => false
    t.string_array "sizes"
    t.boolean      "sold_out",                                :default => false
  end

  add_index "sales", ["brand_id"], :name => "index_sales_on_brand_id"
  add_index "sales", ["category_id", "sizes", "created_at"], :name => "index_sales_on_category_id_and_sizes_and_created_at"
  add_index "sales", ["created_notifications"], :name => "index_sales_on_created_notifications"
  add_index "sales", ["editors_pick"], :name => "index_sales_on_editors_pick"
  add_index "sales", ["sizes"], :name => "index_sales_on_sizes"
  add_index "sales", ["store_id"], :name => "index_sales_on_store_id"

  create_table "stores", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stores", ["name"], :name => "index_stores_on_name"
  add_index "stores", ["url"], :name => "index_stores_on_url"

  create_table "users", :force => true do |t|
    t.string   "email",                                             :null => false
    t.string   "passwd_hash",                                       :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "photo"
    t.string   "fb_id"
    t.string   "zip_code"
    t.integer  "city_id"
    t.string   "first_name",                                        :null => false
    t.string   "last_name",                                         :null => false
    t.text     "bio"
    t.boolean  "notify_faved"
    t.boolean  "notify_followed"
    t.boolean  "notify_posted"
    t.boolean  "notify_comment",                 :default => true
    t.boolean  "is_merchant",                    :default => false
    t.string   "retail_category"
    t.string   "business_name"
    t.string   "custom_slug"
    t.text     "website_url"
    t.string   "gender",            :limit => 1
    t.boolean  "activated_web",                  :default => false
    t.string   "custom_slug_lower"
  end

  add_index "users", ["custom_slug"], :name => "index_users_on_custom_slug", :unique => true
  add_index "users", ["custom_slug_lower"], :name => "index_users_on_custom_slug_lower", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["fb_id"], :name => "index_users_on_fb_id", :unique => true

end
