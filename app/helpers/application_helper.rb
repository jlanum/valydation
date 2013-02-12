module ApplicationHelper

  def user_custom_slug_url(user)
    return nil unless user
    if user.custom_slug and user.custom_slug.size > 0
      custom_slug_url(user.custom_slug)
    else
      user_url(user.id)
    end
  end
end
