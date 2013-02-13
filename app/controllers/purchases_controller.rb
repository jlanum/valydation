class PurchasesController < ApplicationController
  before_filter :handle_device
  before_filter :require_user

  def new
    @sale = Sale.find(params[:sale_id])
    calculate_total

    @tr_data = Braintree::TransparentRedirect.transaction_data(
      :redirect_url => purchase_confirmation_url,
      :transaction => {
        :custom_fields => {"sale_id" => @sale.id},
        :type => "sale",
        :amount => @total_amount})
  end


  def confirmation
    braintree_result = Braintree::TransparentRedirect.confirm(request.query_string)
    transaction = braintree_result.transaction
    if braintree_result.success?
      @purchase = Purchase.new(:user_id => @user.id,
                               :sale_id => transaction.custom_fields[:sale_id],
                               :status => "approved",
                               :card_last_4 => transaction.credit_card_details.last_4,
                               :external_id => transaction.id,
                               :external_status => transaction.status,
                               :external_message => transaction.processor_response_text)
      @purchase.save!
    else
      flash[:message] = "The transaction was declined. Please ensure that your credit card details are entered correctly, and try again."
      sale_id = braintree_result.transaction.custom_fields[:sale_id]
      exp_month, exp_year = braintree_result.transaction.credit_card_details.expiration_date.split("/").collect(&:to_i).collect(&:to_s)
      first_name = braintree_result.transaction.customer_details.first_name
      last_name = braintree_result.transaction.customer_details.last_name
      redirect_to new_sale_purchase_url(:sale_id => sale_id,
                                        :exp_month => exp_month,
                                        :exp_year => exp_year,
                                        :first_name => first_name,
                                        :last_name => last_name)
    end
  end

  def calculate_total
    puts "http://api.zip-tax.com/request/v20?key=VJNRDXJ&postalcode=#{@sale.user.zip_code}"
    tax_results = JSON.parse(open("http://api.zip-tax.com/request/v20?key=VJNRDXJ&postalcode=#{@sale.user.zip_code}").read)

    sales_tax_rate = tax_results["results"].first["taxSales"]
    @tax_amount = @sale.sale_price * sales_tax_rate
    @total_amount = @sale.sale_price + @tax_amount
  end

end
