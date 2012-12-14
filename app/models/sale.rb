class Sale < ActiveRecord::Base
  attr_accessible :user_id,
                  :brand,
                  :sale_price,
                  :orig_price,
                  :percent_off,
                  :product,
                  :category_id,
                  :store_name,
                  :store_url

  mount_uploader :image_0, SaleImageUploader
  mount_uploader :image_1, SaleImageUploader
  mount_uploader :image_2, SaleImageUploader

  def image_url(i)
    "http://s3.amazonaws.com/#{ApplicationController.s3_bucket}/#{self.image_url_slug(i)}"
  end

  def image_url_slug(i)
    "sale_#{self.id}_image_#{i}.jpg"
  end

  def image_0_url
    self.image_url(0) if self.has_image_0
  end

  def image_1_url
    self.image_url(1) if self.has_image_1
  end
  
  def image_2_url
    self.image_url(2) if self.has_image_2
  end

end
