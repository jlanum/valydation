class NotificationsController < ApplicationController
  #require basic auth
  
  def push
    limit = params[:limit].to_i
    if limit > 100 or limit < 1
      limit = 10
    end

    @notifications = Notification.
      where(["sent = ? AND retries < ?", false, 3]).
      order("created_at ASC").
      limit(limit).all
    
    if @notifications.length == 0
      render :json => []
      return
    end

    pusher = Grocer.pusher(GrocerConfig)

    @notifications.each do |notification|
      begin
        notification.send!(pusher)
      rescue
        ##loggy?
      end
    end
   
    render :json => @notifications.to_json
  end

  def feedback
    feedback = Grocer.feedback(GrocerConfig)

    @attempts = []

    feedback.each do |response|
      attempt = {:token => response.device_token,
                 :timestamp => response.timestamp}
      if device = Device.find_by_apns_token(response.device_token)
        attempt[:device_id] = device.id
        if user = device.user
          user.unregister_push!
          attempt[:user_id] = user.id
        end
      end
      @attempts << attempt
    end

    render :json => @attempts.to_json
  end

end
