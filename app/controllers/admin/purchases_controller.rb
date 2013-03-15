class Admin::PurchasesController < ApplicationController
  before_filter :admin_auth
  
  layout "admin"

  def index
    @purchases = Purchase.
      page(params[:page]).
      per(50).
      order("created_at DESC")
  end

end
