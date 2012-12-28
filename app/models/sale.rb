class Sale < ActiveRecord::Base
  attr_accessible :user_id,
                  :brand,
                  :sale_price,
                  :orig_price,
                  :percent_off,
                  :product,
                  :category_id,
                  :size,
                  :store_name,
                  :store_url,
                  :display_address,
                  :address,
                  :city,
                  :state,
                  :postal_code,
                  :country,
                  :latitude,
                  :longitude,
                  :user_lat,
                  :user_lon,
                  :city_id,
                  :store_id,
                  :brand_id

  attr_accessor :current_user

  monetize :orig_price_cents, :allow_nil => true
  monetize :sale_price_cents, :allow_nil => true

  mount_uploader :image_0, SaleImageUploader
  mount_uploader :image_1, SaleImageUploader
  mount_uploader :image_2, SaleImageUploader

  has_many :comments, :dependent => :destroy
  has_many :faves, :dependent => :destroy, :class_name => "Fave"
  belongs_to :user

  before_create :set_store
  before_create :set_brand


  def create_notifications!(recreate = false)
    if self.created_notifications and not recreate
      return false
    end

    notifications = []
    alert_message = "#{self.user.display_name} posted a sale in your area."

    User.where(:city_id => self.city_id,
               :notify_posted => true).each do |user|
      next if user.id == self.user.id

      user.devices.each do |device|
        n = Notification.new(:user_id => user.id,
                             :device_id => device.id,
                             :source_type => "Sale",
                             :source_id => self.id,
                             :alert => alert_message)
        n.save
        notifications << n
      end
    end

    self.created_notifications = true
    self.created_notifications_at = Time.now
    self.save

    notifications
  end

  def set_store
    unless @store = Store.find_by_url(self.store_url)
      @store = Store.create!(:url => self.store_url,
                             :name => self.store_name)
    end
    self.store_id = @store.id
  end
  
  def set_brand
    unless @brand = Brand.find_by_name(self.brand.upcase)
      @brand = Brand.create!(:name => self.brand.upcase)
    end
    self.brand_id = @brand.id
  end

  def my_fave_old
    raise "no user for my fave" unless self.current_user
    Fave.where(sale_id: self.id, user_id: self.current_user.id).first
  end

  def my_fave
    return nil unless self.my_fave_id
    {:id => self.my_fave_id.to_i}
  end

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
