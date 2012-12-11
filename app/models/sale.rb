class Sale < ActiveRecord::Base
  attr_accessible :user_id,
                  :brand,
                  :sale_price,
                  :orig_price,
                  :product,
                  :category_id,
                  :store_name,
                  :store_url


end
