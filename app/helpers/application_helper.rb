module ApplicationHelper

  def user_custom_slug_url(user)
    return nil unless user
    if user.custom_slug and user.custom_slug.size > 0
      custom_slug_url(user.custom_slug)
    else
      user_url(user.id)
    end
  end

  def twitter_share_url(sale)
    "https://twitter.com/share?url=#{CGI.escape(sale_url(sale))}&text=#{CGI.escape(sale.t_share_message)}"
  end

  def fb_share_url(sale)
    "http://www.facebook.com/sharer.php?s=100&p[title]=MySaleTable&p[summary]=#{CGI.escape(sale.share_message)}&p[url]=#{CGI.escape(sale_url(sale))}"
  end

end
