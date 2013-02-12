class PurchasesController < ApplicationController

  def new
    @sale = Sale.find(params[:sale_id])
    calculate_total
  end


  def calculate_total
    puts "http://api.zip-tax.com/request/v20?key=VJNRDXJ&postalcode=#{@sale.user.zip_code}"
    tax_results = JSON.parse(open("http://api.zip-tax.com/request/v20?key=VJNRDXJ&postalcode=#{@sale.user.zip_code}").read)

    sales_tax_rate = tax_results["results"].first["taxSales"]
    @tax_amount = @sale.sale_price * sales_tax_rate
    @total_amount = @sale.sale_price + @tax_amount
  end

end
