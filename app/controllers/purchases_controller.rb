class PurchasesController < ApplicationController

  def new
    @sale = Sale.find(params[:sale_id])
    calculate_total

    @tr_data = Braintree::TransparentRedirect.transaction_data(
      :redirect_url => purchase_confirmation_url,
      :transaction => {
        :type => "sale",
        :amount => @total_amount})
  end

  def confirmation
    braintree_result = Braintree::TransparentRedirect.confirm(query_string)

  end

  def calculate_total
    puts "http://api.zip-tax.com/request/v20?key=VJNRDXJ&postalcode=#{@sale.user.zip_code}"
    tax_results = JSON.parse(open("http://api.zip-tax.com/request/v20?key=VJNRDXJ&postalcode=#{@sale.user.zip_code}").read)

    sales_tax_rate = tax_results["results"].first["taxSales"]
    @tax_amount = @sale.sale_price * sales_tax_rate
    @total_amount = @sale.sale_price + @tax_amount
  end

end
