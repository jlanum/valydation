class Purchase < ActiveRecord::Base
  include MoneyRails::ActionViewExtension

  attr_accessor :tr_data, :post_url

  attr_accessible :user_id,
                  :sale_id,
                  :status,
                  :card_last_4,
                  :external_id,
                  :external_status,
                  :external_message,
                  :address, 
                  :address_2, 
                  :city, 
                  :state, 
                  :zip,
                  :shipping,
                  :tax,
                  :total,
                  :subtotal,
                  :size,
                  :ship_it,
                  :retailer_status,
                  :items,
                  :cart,
                  :purchased_sales,
                  :products_string

  belongs_to :sale
  belongs_to :user
  has_many :purchased_sales

  monetize :shipping_cents, :allow_nil => true
  monetize :tax_cents, :allow_nil => true
  monetize :total_cents, :allow_nil => true
  monetize :subtotal_cents, :allow_nil => true

  def self.statuses
    ["Pending",
     "Confirmed",
     "Shipped",
     "Canceled"]
  end

  def available_key
    Digest::MD5.hexdigest("#{self.purchased_sales.id} #{self.purchased_sales.user_id} #{self.purchased_sales.sale_id} #{self.external_id}")
  end

  def previous_purchases
    Purchase.where(:user_id => self.user_id).
             where(["created_at < ?", (self.created_at || Time.now)]).
             order("created_at DESC")
  end

  def previous_shipped_purchase
    @previous_shipped_purchase ||= previous_purchases.where(:ship_it => true).first
  end

  def calculate_total!
    raise "Can't calculate total without a sale!" if self.purchased_sales.empty?

    if self.ship_it
      self.shipping = 0.0
    else
      self.shipping = 0.0
    end

    self.purchased_sales.each do |p|
      next unless p.sale and p.sale.user and p.sale.user.zip_code.to_s.length >= 5
      tax_results = JSON.parse(open("http://api.zip-tax.com/request/v20?key=VJNRDXJ&postalcode=#{p.sale.user.zip_code}").read)
      sales_tax_rate = tax_results["results"].first["taxSales"]
      p.tax = p.orig_price.to_f * sales_tax_rate.to_f
    end
    
    self.subtotal = self.purchased_sales.
      collect { |s| s.orig_price.to_f }.sum
    self.tax = self.purchased_sales.collect { |s| s.tax.to_f }.sum

    self.total = self.subtotal + self.tax + self.shipping
  end


  def send_initial_emails
    send_customer_processing_email
    
  end

  def send_customer_processing_email
    products_string = ActionController::Base.new.
      render_to_string("purchases/products_email", 
                       :layout => false, 
                       :locals => {:purchased_sales => self.purchased_sales,
                                                          :purchase => self})

    md_temp_options = { 
      :template_name => "valydation-processing-your-sale", 
      :template_content => [{:name => "product_email_stuff", :content => products_string}], 
      :message => { 
        :subject => "Processing Your Sale", 
        :from_email => "hi@valydation.com", 
        :from_name => "/valydation", 
        :to => [{:email => self.user.email, "patricia@valydation.com"}], 
        :merge_vars => [{:rcpt => self.user.email, 
                         :vars => common_merge_vars}]
      }
    }
    
    m_api = Mandrill::API.new(ApplicationController.mandrill_api_key)
    m_api.messages(:sendtemplate, md_temp_options)
  end
  
 
  def send_merchant_confirm_email
    products_string = ActionController::Base.new.
      render_to_string("purchases/products_email", 
                       :layout => false, 
                       :locals => {:purchased_sales => self.purchased_sales,
                                                          :purchase => self})
                       
    md_temp_options = { 
      :template_name => "merchant-customer-information", 
      :template_content => [{:name => "product_email_stuff", :content => products_string}], 
      :message => { 
        :subject => "You have a customer", 
        :from_email => "hi@valydation.com", 
        :from_name => "/valydation", 
        :to => [{:email => "patricia@valydation.com"}], 
        :merge_vars => [{:rcpt => "patricia@valydation.com", 
                         :vars => common_merge_vars}]
      }
    }
    
    m_api = Mandrill::API.new(ApplicationController.mandrill_api_key)
    m_api.messages(:sendtemplate, md_temp_options)
  end
  


  def send_available_email
    md_temp_options = { 
      :template_name => "mysaletable-item-is-available", 
      :template_content => [{:name => "sale_image", :content => ""}], 
      :message => { 
        :subject => "Item is available", 
        :from_email => "hi@valydation.com", 
        :from_name => "/valydation", 
        :to => [{:email => "hi@valydation.com"}], 
        :merge_vars => [{:rcpt => "hi@valydation.com", 
                         :vars => common_merge_vars}]
      }
    }

    m_api = Mandrill::API.new(ApplicationController.mandrill_api_key)
    m_api.messages(:sendtemplate, md_temp_options)
  end

  def send_not_available_email
    md_temp_options = { 
      :template_name => "mysaletable-item-is-not-available", 
      :template_content => [{:name => "sale_image", :content => ""}], 
      :message => { 
        :subject => "Item is not available", 
        :from_email => "hi@valydation.com", 
        :from_name => "/valydation", 
        :to => [{:email => "hi@valydation.com"}], 
        :merge_vars => [{:rcpt => "hi@valydation.com", 
                         :vars => common_merge_vars}]
      }
    }

    m_api = Mandrill::API.new(ApplicationController.mandrill_api_key)
    m_api.messages(:sendtemplate, md_temp_options)
  end

  def common_merge_vars
   ## base_available_url = "http://www.valydation.com/purchase_available?id=#{self.id}&key=#{self.available_key}"
    
    
    merge_vars = {
     ## "ORDER_ID" => self.id,
     ## "IMAGE_URL" => self.purchased_sales.image_0.versions[:web_index].to_s,
      ##"AVAILABLE_URL" => base_available_url + "&available=1",
     ## "NOT_AVAILABLE_URL" => base_available_url + "&available=0",
     ##  "BRAND" => self.purchased_sales.collect { |s| s.brand }.flatten,
     ##  "PRODUCT" => self.purchased_sales.collect { |s| s.product }.second,
     ##  "SIZE" => self.purchased_sales.collect { |s| s.sizes }.flatten,
      ##"DELIVER" => ((p.shipping.to_f > 0) ? "Yes" : "No"),
    ##"SUBTOTAL" => humanized_money_with_symbol (self.subtotal),
    ##"TAX" => humanized_money_with_symbol(self.tax),
    ## "TOTAL" => humanized_money_with_symbol(self.total)
    }
   
    merge_vars.inject([]) do |array, pair|
      array << {:name => pair.first, :content => self.purchased_sales.collect { |s| s.brand }.flatten}
    end
  end

end
