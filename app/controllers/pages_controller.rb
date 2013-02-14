class PagesController < ApplicationController
  before_filter :handle_user

  def show
    @page = Page.where(:slug => params[:slug]).first
    @title = @page.title unless @page.title.to_s.empty?
    if @page
      use_layout = (@user ? "application" : "prelogin")
      render :layout => use_layout
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def contact
    if params[:email]
      #send email here
      flash[:message] = "Your message has been sent, and we'll get back to you soon."
      redirect_to sales_url
    end
  end
end
