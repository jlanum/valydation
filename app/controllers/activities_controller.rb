class ActivitiesController < ApplicationController
  before_filter :handle_device
  before_filter :require_user

  def index
    @activities = Activity.where(:user_id => @user.id).
                    includes([:actor, :sale]).
                    order("created_at DESC").
                    limit(20).
                    offset(params[:offset])

    respond_to do |wants|
      wants.json do 
        render :json => @activities.to_json(:include => {:actor => User.public_json, 
                                                         :sale => {:id => {}}})
      end
    end

  end
end
