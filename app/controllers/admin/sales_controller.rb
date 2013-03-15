class Admin::SalesController < ApplicationController
  before_filter :admin_auth

  layout "admin"

  def index
    @sales = Sale.page(params[:page]).
      per(50).
      order("created_at DESC").
      includes([:metro, :user])

  end

  def edit
    @sale = Sale.find(params[:id])
    @cities = City.order("name ASC").all
  end

  def show
    redirect_to edit_admin_sale_url(params[:id])
  end

  def update
    @sale = Sale.find(params[:id])

    @sale.update_attributes(params[:sale])
    @sale.save!

    @cities = City.order("name ASC").all
    @message = "The sale has been updated."
  
    render :template => "admin/sales/edit"
  end

  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy

    flash[:message] = "The sale has been deleted"
    redirect_to admin_sales_url
  end

end
