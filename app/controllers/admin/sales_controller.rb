class Admin::SalesController < ApplicationController
  layout "admin"

  def index
    @sales = Sale.page(params[:page]).
      per(10).
      order("created_at DESC")

  end

end
