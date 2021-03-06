class PurchasesController < ApplicationController
  before_filter :handle_device
  before_filter :require_user, :except => "available"
  before_filter :require_ssl, :except => "available"
  before_filter :get_cart
  before_filter :view_cart

### Cart stuff
### note from Max to Jesse - I recommend moving everything between here
### and the "purchases stuff" comment below into a separate controller 
### called "cartcontroller" or something of the like.
### Just for reasons of clear code organization, there is no functional benefit...
  

  def add_to_cart
    get_cart
    @cart.add_to_cart(Sale.find(params[:sale_id]))
    save_cart
    redirect_to view_cart_url
  end

  def remove_from_cart
    get_cart
    @cart.remove_from_cart(Sale.find(params[:sale_id]))
    save_cart
    redirect_to view_cart_url
  end

  def view_cart
    get_cart
  end

  def clear_cart
    get_cart
    @cart.clear
    save_cart
  end

  ## should put this and the next method in ApplicationController so they're available in all controllers
  def save_cart
    session[:cart_json] = @cart.to_json
  end

  def get_cart
    if session[:cart_json]
      @cart = Cart.from_json(session[:cart_json])
    else
      @cart = Cart.new
    end
  end 

### Purchases stuff 

  def index
    @purchases = Purchase.where(:user_id => @user.id).
                  order("created_at DESC").all
   
  end

  def sold
    @purchased_sales = Purchased_sale.
      joins("LEFT JOIN sales on purchases.sale_id=sales.id").
      where(["sales.user_id=?",@user.id]).
      order("created_at DESC").all
  end

  def available
    @purchase = Purchase.find(params[:id])
    if @purchase.available_key == params[:key]
      if params[:available].to_i == 1
        @purchase.send_available_email
        redirect_to page_url(:slug => "item-available-thanks")        
      else
        @purchase.send_not_available_email
        redirect_to page_url(:slug => "item-not-available-thanks")        
      end
    end
  end

  def new
    get_cart
    @purchase = Purchase.new(:user_id => @user.id)
    @purchase.purchased_sales = @cart.items.collect do |sale|
      sale.to_purchased_sale
    end
    @purchase.calculate_total!

    sale_ids = @purchase.purchased_sales.collect(&:sale_id).join(",")

    @tr_data = Braintree::TransparentRedirect.transaction_data(
      :redirect_url => purchase_confirmation_url,
      :transaction => {
        :custom_fields => {"sale_id" => sale_ids,
                           "shipping_amount" => @purchase.shipping,
                           "tax_amount" => @purchase.tax,
                           "subtotal" => @purchase.subtotal},
        :type => "sale",
        :amount => @purchase.total,
        
        :options => {
                  :submit_for_settlement => true
                }})

    @purchase.tr_data = @tr_data
    @purchase.post_url = Braintree::TransparentRedirect.url

    respond_to do |wants|
      wants.html { new_html }
    end
  end
  
  def products_email
    @purchase = Purchase.where(:user_id => @user.id)
  end
  
  def new_json
    render :json => @purchase.to_json(:methods => [:previous_shipped_purchase, :tr_data, :post_url])
  end

  def new_html
    if request.xhr?
      if params[:transaction]
        if params[:transaction][:customer]
          params[:first_name] = params[:transaction][:customer][:first_name]
          params[:last_name] = params[:transaction][:customer][:last_name]
        end
        if params[:transaction][:credit_card]
          params[:exp_month] = params[:transaction][:credit_card][:expiration_month]
          params[:exp_year] = params[:transaction][:credit_card][:expiration_year]
          params[:cc_number] = params[:transaction][:credit_card][:number]
          params[:cvv] = params[:transaction][:credit_card][:cvv]
        end
        if params[:transaction][:custom_fields]
          params[:size] = params[:transaction][:custom_fields][:size]
        end
      end
      render :partial => "purchases/form"
    end
  end

  def confirmation
    braintree_result = Braintree::TransparentRedirect.confirm(request.query_string)
    transaction = braintree_result.transaction
    if braintree_result.success?
      #debugger
      ship_it = (transaction.shipping_details.street_address and not transaction.shipping_details.street_address.empty?)

      sale_ids = transaction.custom_fields[:sale_id].split(",").collect(&:to_i)
      purchased_sales = sale_ids.collect do |sale_id|
        Sale.where(:id => sale_id).first.to_purchased_sale
      end

      @purchase = Purchase.new(:user_id => @user.id,
                               :purchased_sales => purchased_sales,
                               :status => "approved",
                               :card_last_4 => transaction.credit_card_details.last_4,
                               :external_id => transaction.id,
                               :external_status => transaction.status,
                               :external_message => transaction.processor_response_text,
                               :address => transaction.shipping_details.street_address,
                               :address_2 => transaction.shipping_details.extended_address,
                               :city => transaction.shipping_details.locality,
                               :state => transaction.shipping_details.region,
                               :zip => transaction.shipping_details.postal_code,
                               :shipping => transaction.custom_fields[:shipping_amount],
                               :tax => transaction.custom_fields[:tax_amount],
                               :subtotal => transaction.custom_fields[:subtotal],
                               :total => transaction.amount,
                               :size => transaction.custom_fields[:size],
                               :ship_it => ship_it)
      
      @purchase.save!
      clear_cart
      
      respond_to do |wants|
        wants.json do 
          render :json =>  {"message" => "We're holding your item and are awaiting confirmation from the merchant. Your credit card will be charged once the sale is confirmed."}
        end
        wants.html { }
      end
    else
      #debugger
      @error_message = "The transaction was declined. Please ensure that your credit card details are entered correctly, and try again."
      flash[:message] = @error_message

      exp_month, exp_year, first_name, last_name, address, 
        address_2, city, state, zip, ship = nil

      #size = braintree_result.params[:transaction][:custom_fields][:size]        
      if braintree_result.params[:transaction][:credit_card]
        exp_month = braintree_result.params[:transaction][:credit_card][:expiration_month]
        exp_year = braintree_result.params[:transaction][:credit_card][:expiration_year]
      end
      if braintree_result.params[:transaction][:customer]
        first_name = braintree_result.params[:transaction][:customer][:first_name]
        last_name = braintree_result.params[:transaction][:customer][:last_name]
      end
      if braintree_result.params[:transaction][:shipping]
        address = braintree_result.params[:transaction][:shipping][:street_address]
        address_2 = braintree_result.params[:transaction][:shipping][:extended_address]
        city = braintree_result.params[:transaction][:shipping][:locality]
        state = braintree_result.params[:transaction][:shipping][:region]
        zip = braintree_result.params[:transaction][:shipping][:postal_code]
        ship = 1
      end

      respond_to do |wants|
        wants.json do
          render :json => {"error" => @error_message}
        end
        wants.html do
          redirect_to new_sale_purchase_url(:exp_month => exp_month,
                                            :exp_year => exp_year,
                                            :first_name => first_name,
                                            :last_name => last_name,
                                            :address => address,
                                            :address_2 => address_2,
                                            :city => city,
                                            :state => state,
                                            :zip => zip,
                                            :ship => ship)
        end
      end
    end
  end



end




