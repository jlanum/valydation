require 'csv'

class Admin::LeadsController < ApplicationController
  before_filter :admin_auth, :only => :index  

  def create
    @lead = Lead.new(:first_name => params[:first_name],
                     :last_name => params[:last_name],
                     :email => params[:email])
    @lead.save!

    redirect_to :back
  end

  def index
    @leads = Lead.order("created_at DESC").all
      csv_string = CSV.generate do |csv|
        csv << ["first","last","email","date"]
        @leads.each do |lead|
          csv << [lead.first_name, lead.last_name, lead.email, 
                  lead.created_at.strftime("%d-%b-%Y")]
        end
      end

      send_data csv_string, 
                :type => 'text/csv; charset=iso-8859-1; header=present', 
                :disposition => "attachment; filename=mst_leads.csv" 
    
  end
end
