class Admin::PurchasesController < ApplicationController
  before_filter :admin_auth
  
  layout "admin"

  def index
    @purchases = Purchase.
      page(params[:page]).
      per(50).
      order("created_at DESC")
  end

  def edit
    @purchase = Purchase.find(params[:id])
  end
  
  def update
    @purchase = Purchase.find(params[:id])

    @purchase.update_attributes(params[:purchase])
    @purchase.save!

    @message = "The purchase has been updated."
  
    render :template => "admin/purchases/edit"
  end


  def destroy
    @purchase = Purchase.find(params[:id])
    @purchase.destroy

    flash[:message] = "The purchase has been deleted"
    redirect_to admin_purchases_url
  end

end
