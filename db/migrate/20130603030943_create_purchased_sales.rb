class CreatePurchasedSales < ActiveRecord::Migration
  def change
    create_table :purchased_sales do |t|
      t.integer      "sale_id"
      t.integer      "purchase_id", :null => false
      t.string       "brand",                    :limit => 128,                    :null => false
      t.string       "product",                  :limit => 128,                    :null => false
      t.string       "image_0"
      t.string       "image_1"
      t.string       "image_2"
      t.string       "image_3"
      t.string       "image_4"
      t.string       "image_5"
      t.string       "image_6"
      t.string       "image_7"
      t.float        "percent_off"
      t.text         "display_address"
      t.string       "size",                     :limit => 32
      t.string_array "sizes"
      t.integer      "orig_price_cents",                        :default => 0,     :null => false
      t.string       "orig_price_currency",                     :default => "USD", :null => false
      t.integer      "sale_price_cents",                        :default => 0,     :null => false
      t.string       "sale_price_currency",                     :default => "USD", :null => false
      t.integer      "tax_cents", :default => 0, :null => false
      t.string       "tax_currency", :default => "USD", :null => false
      t.boolean      "does_shipping",                           :default => false
      t.boolean      "allow_returns",                           :default => false
      t.string       "condition"
      t.boolean      "validated",                               :default => false
      t.string       "source"
      t.text         "product_history"
      t.timestamps
    end
  end
end
