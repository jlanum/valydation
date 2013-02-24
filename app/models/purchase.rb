class Purchase < ActiveRecord::Base
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
                  :subtotal

  belongs_to :sale
  belongs_to :user

  monetize :shipping_cents, :allow_nil => true
  monetize :tax_cents, :allow_nil => true
  monetize :total_cents, :allow_nil => true
  monetize :subtotal_cents, :allow_nil => true

  def send_initial_emails
    md_temp_options = { 
      :template_name => "test-template", 
      :template_content => [{:name => "blah", :content => ""}], 
      :message => { 
        :subject => "testo", 
        :from_email => "shop@mysaletable.com", 
        :from_name => "MySaleTable", 
        :to => [{:email => self.user.email}], 
        :merge_vars => [{:rcpt => self.user.email, 
                         :vars => [{:name => "MERGETAG", :content => "TESTO!!"}] }]
      }
    }
  
    m_api = Mandrill::API.new(ApplicationController.mandrill_api_key)
    m_api.messages(:sendtemplate, md_temp_options)
  end
end
