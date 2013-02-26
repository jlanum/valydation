class Purchase < ActiveRecord::Base
  include MoneyRails::ActionViewExtension

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
                  :size

  belongs_to :sale
  belongs_to :user

  monetize :shipping_cents, :allow_nil => true
  monetize :tax_cents, :allow_nil => true
  monetize :total_cents, :allow_nil => true
  monetize :subtotal_cents, :allow_nil => true

  def available_key
    Digest::MD5.hexdigest("#{self.id} #{self.user_id} #{self.sale_id} #{self.external_id}")
  end

  def send_initial_emails
    send_customer_processing_email
    send_merchant_confirm_email
  end

  def send_customer_processing_email
    md_temp_options = { 
      :template_name => "customer-processing-your-sale", 
      :template_content => [{:name => "sale_image", :content => ""}], 
      :message => { 
        :subject => "Processing Your Sale", 
        :from_email => "shop@mysaletable.com", 
        :from_name => "MySaleTable", 
        :to => [{:email => self.user.email}], 
        :merge_vars => [{:rcpt => self.user.email, 
                         :vars => common_merge_vars}]
      }
    }
  
    m_api = Mandrill::API.new(ApplicationController.mandrill_api_key)
    m_api.messages(:sendtemplate, md_temp_options)
  end

  def send_merchant_confirm_email
    md_temp_options = { 
      :template_name => "merchant-confirm-sale", 
      :template_content => [{:name => "sale_image", :content => ""}], 
      :message => { 
        :subject => "You have a customer", 
        :from_email => "shop@mysaletable.com", 
        :from_name => "MySaleTable", 
        :to => [{:email => self.sale.user.email}], 
        :merge_vars => [{:rcpt => self.sale.user.email, 
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
        :from_email => "shop@mysaletable.com", 
        :from_name => "MySaleTable", 
        :to => [{:email => "shop@mysaletable.com"}], 
        :merge_vars => [{:rcpt => "shop@mysaletable.com", 
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
        :from_email => "shop@mysaletable.com", 
        :from_name => "MySaleTable", 
        :to => [{:email => "shop@mysaletable.com"}], 
        :merge_vars => [{:rcpt => "shop@mysaletable.com", 
                         :vars => common_merge_vars}]
      }
    }

    m_api = Mandrill::API.new(ApplicationController.mandrill_api_key)
    m_api.messages(:sendtemplate, md_temp_options)
  end

  def common_merge_vars
    base_available_url = "http://www.mysaletable.com/purchase_available?id=#{self.id}&key=#{self.available_key}"

    merge_vars = {
      "ORDER_ID" => self.id,
      "IMAGE_URL" => self.sale.image_0.versions[:web_modal].to_s,
      "AVAILABLE_URL" => base_available_url + "&available=1",
      "NOT_AVAILABLE_URL" => base_available_url + "&available=0",
      "BRAND" => self.sale.brand,
      "PRODUCT" => self.sale.product,
      "SIZE" => self.sale.size,
      "STORE" => self.sale.store_name,
      "DELIVER" => ((self.shipping.to_f > 0) ? "Yes" : "No"),
      "SUBTOTAL" => humanized_money_with_symbol(self.subtotal),
      "SHIPPING" => humanized_money_with_symbol(self.shipping),
      "TAX" => humanized_money_with_symbol(self.tax),
      "TOTAL" => humanized_money_with_symbol(self.total)
    }

    merge_vars.inject([]) do |array, pair|
      array << {:name => pair.first, :content => pair.last}
    end
  end

end
