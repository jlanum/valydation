class PagesController < ApplicationController
  before_filter :handle_user
  before_filter :get_cart
  before_filter :view_cart

  

  def css
    @page = Page.where(:slug => params[:slug]).first
    if @page
      render :text => @page.content, :layout => false, :content_type => 'text/css'
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
  

  def show
    @page = Page.where(:slug => params[:slug]).first
    @title = @page.title unless @page.title.to_s.empty?
    if @page
      if @page.content.match(/<html/)
        use_layout = false
      else
        use_layout = (@user ? "application" : "prelogin")
      end
      render :layout => use_layout
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
  
  def consignment
    if params[:email]
      #send email here
      ShopMailer.consignment_email(params[:name], 
                               params[:email], 
                               params[:subject],
                               params[:city],
                               params[:state],
                               params[:zip_code],
                               params[:country],
                               params[:phone_number], 
                               params[:message]).deliver
      flash[:message] = "Your message has been sent, and we'll get back to you soon."
      redirect_to sales_url
    
 end
end

  def contact
    if params[:email]
      #send email here
      ShopMailer.contact_email(params[:name], 
                               params[:email], 
                               params[:subject], 
                               params[:message]).deliver
      flash[:message] = "Your message has been sent, and we'll get back to you soon."
      redirect_to sales_url
    end
  end
end
