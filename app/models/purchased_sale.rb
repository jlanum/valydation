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
                  :image_0,
                  :image_1,
                  :image_2,
                  :image_3,
                  :image_4,
                  :image_5,
                  :image_6,
                  :image_7

  belongs_to :purchase
  belongs_to :sale

  monetize :orig_price_cents, :allow_nil => true
  monetize :sale_price_cents, :allow_nil => true
  monetize :tax_cents, :allow_nil => true
end
