class RedoLandingStatic < ActiveRecord::Migration
  def up
    Page.where(:slug => "landing").first.destroy
    Page.load_unloaded
  end

  def down
  end
end
