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
                  :brand_id,
                  :visible,
                  :percent_off_int,
                  :does_shipping,
                  :allow_returns,
                  :editors_pick

  attr_accessor :current_user
  attr_accessor :image_upload_urls

  monetize :orig_price_cents, :allow_nil => true
  monetize :sale_price_cents, :allow_nil => true

  mount_uploader :image_0, SaleImageUploader
  mount_uploader :image_1, SaleImageUploader
  mount_uploader :image_2, SaleImageUploader

  has_many :comments, :dependent => :destroy
  has_many :faves, :dependent => :destroy, :class_name => "Fave"
  belongs_to :user
  belongs_to :metro, :class_name => "City", :foreign_key => "city_id"

  before_save :set_store
  before_save :set_brand
  before_save :set_sizes

  def self.categories
    ["Women",
     "Men",
     "Kids",
     "Home",
     "Pet"]
  end

  #def sizes
    #self.size.to_s.split(",").collect(&:strip)
  #end

  def share_message
    "#{self.user.display_name if self.user} discovered #{self.brand} #{self.product} for #{(self.percent_off.to_f*100).round}% off on MySaleTable."
  end

  def t_share_message
    "I discovered #{self.brand} #{self.product} for #{(self.percent_off.to_f*100).round}% off on
@MySaleTable."
  end

  def process_images!
    full_session = ApplicationController.new_sts_session
    s3_full = AWS::S3.new(full_session.credentials)
    bucket = s3_full.buckets["#{ApplicationController.s3_bucket}"]

    (0..2).each do |image_index|
      if image_key = self.send("temp_image_url_#{image_index}")
        puts "processing #{image_key}"
        s3_obj = bucket.objects[image_key]
        temp_filename = "image_#{Time.now.strftime("%Y_%m_%d_%H%M%S")}_#{self.id}_#{rand(10000000000)}.jpg"
        temp_file_path = "#{Rails.root}/tmp/#{temp_filename}"

        File.open(temp_file_path,"wb") do |f|
          s3_obj.read { |chunk| f.write(chunk) }
        end

        self.send("image_#{image_index}=",File.open(temp_file_path))
      end
    end

    self.processed_images = true
    self.save!
  end

  def create_s3_image_upload(federated_session)
    s3 = AWS::S3.new(federated_session.credentials)
    image_key = "image_#{Time.now.strftime("%Y_%m_%d_%H%M%S")}_#{self.id}_#{rand(10000000000)}.jpg"
    bucket = s3.buckets["#{ApplicationController.s3_bucket}/raw_uploads"]
    s3_obj = bucket.objects[image_key]
    s3_obj.write("")
    url = s3_obj.url_for(:write)
    
    {:key => image_key, :url => url}
  end

  def create_notifications!(recreate = false)
    if self.created_notifications and not recreate
      return false
    end

    notifications = []
    alert_message = "#{self.user.first_name} #{self.user.last_name} posted a sale."
    alert_custom = {"sale_id" => self.id}

    self.user.following_users.where(:notify_posted => true).each do |user|
      user.devices.each do |device|
        n = Notification.new(:user_id => user.id,
                             :device_id => device.id,
                             :source_type => "Sale",
                             :source_id => self.id,
                             :alert => alert_message,
                             :custom => alert_custom.to_json)
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

  def set_sizes
    self.sizes = self.size.to_s.split(",").collect(&:strip)
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

  def percent_off_int
    (self.percent_off * 100).round
  end

  def percent_off_int=(int_value)
    self.percent_off = int_value.to_f / 100
  end

end
