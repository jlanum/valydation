class AddPreregisterPage < ActiveRecord::Migration
  def up
    Page.load_unloaded    
  end

  def down
    if page = Page.where(:slug => "preregister").first
      page.destroy    
    end
  end
end
