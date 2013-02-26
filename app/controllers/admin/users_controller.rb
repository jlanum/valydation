require 'csv'

class Admin::UsersController < ApplicationController
  http_basic_authenticate_with :name => "admin", :password => "Green1994"
  
  layout "admin"

  def index
    @users = User.page(params[:page]).
      order("created_at DESC").
      per(50).
      includes([:city, :sales])
  end

  def export
    @users = User.order("created_at DESC").all
    csv_string = CSV.generate do |csv|
      csv << ["first","last","email","date"]
      @users.each do |user|
        csv << [user.first_name, user.last_name, user.email, 
                user.created_at.strftime("%d-%b-%Y")]
      end
    end

    send_data csv_string, 
              :type => 'text/csv; charset=iso-8859-1; header=present', 
              :disposition => "attachment; filename=mst_users.csv" 
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:message] = "The user has been deleted"
    redirect_to admin_users_url
  end
end
