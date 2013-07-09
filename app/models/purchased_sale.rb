class PurchasedSale < ActiveRecord::Base
  attr_accessible :sale_id,
                  :brand,
                  :product,
                  :size,
                  :sizes,
                  :orig_price,
                  :sale_price,
                  :does_shipping,
                  :allow_returns,
                  :condition,
                  :validated,
                  :source,
                  :product_history,
                  :product_specifics,
                  :product_condition,
                  :image_0,
                  :image_1,
                  :image_2,
                  :image_3,
                  :image_4,
                  :image_5,
                  :image_6,
                  :image_7,
                  :purchase_id,
                  :display_address

  belongs_to :purchase
  belongs_to :sale

  monetize :orig_price_cents, :allow_nil => true
  monetize :sale_price_cents, :allow_nil => true
  monetize :tax_cents, :allow_nil => true
end
