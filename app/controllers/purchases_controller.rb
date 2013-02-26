class PurchasesController < ApplicationController
  before_filter :handle_device
  before_filter :require_user, :except => "available"
  before_filter :require_ssl, :except => "available"

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
    @sale = Sale.find(params[:sale_id])
    calculate_total

    @tr_data = Braintree::TransparentRedirect.transaction_data(
      :redirect_url => purchase_confirmation_url,
      :transaction => {
        :custom_fields => {"sale_id" => @sale.id,
                           "shipping_amount" => @ship_amount,
                           "tax_amount" => @tax_amount,
                           "subtotal" => @sale.sale_price},
        :type => "sale",
        :amount => @total_amount})

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
      end
      render :partial => "purchases/form"
    end
  end


  def confirmation
    braintree_result = Braintree::TransparentRedirect.confirm(request.query_string)
    transaction = braintree_result.transaction
    if braintree_result.success?
      #debugger
      @purchase = Purchase.new(:user_id => @user.id,
                               :sale_id => transaction.custom_fields[:sale_id],
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
                               :total => transaction.amount)
      @purchase.save!
    else
      flash[:message] = "The transaction was declined. Please ensure that your credit card details are entered correctly, and try again."
      sale_id = braintree_result.transaction.custom_fields[:sale_id]
      exp_month, exp_year = braintree_result.transaction.credit_card_details.expiration_date.split("/").collect(&:to_i).collect(&:to_s)
      first_name = braintree_result.transaction.customer_details.first_name
      last_name = braintree_result.transaction.customer_details.last_name
      address = transaction.shipping.street_address
      address_2 = transaction.shipping.extended_address
      city = transaction.shipping.locality
      state = transaction.shipping.region
      zip = transaction.shipping.postal_code

      redirect_to new_sale_purchase_url(:sale_id => sale_id,
                                        :exp_month => exp_month,
                                        :exp_year => exp_year,
                                        :first_name => first_name,
                                        :last_name => last_name,
                                        :address => address,
                                        :address_2 => address_2,
                                        :city => city,
                                        :state => state,
                                        :zip => zip)
    end
  end

  private

  def calculate_total
    if params[:ship].to_i == 1
      @ship_amount = 5.0
    else
      @ship_amount = 0.0
    end

    tax_results = JSON.parse(open("http://api.zip-tax.com/request/v20?key=VJNRDXJ&postalcode=#{@sale.user.zip_code}").read)

    sales_tax_rate = tax_results["results"].first["taxSales"]
    @tax_amount = @sale.sale_price * sales_tax_rate
    @total_amount = @sale.sale_price.to_f + @tax_amount.to_f + @ship_amount.to_f
  end

end
