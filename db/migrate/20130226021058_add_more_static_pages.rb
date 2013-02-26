class AddMoreStaticPages < ActiveRecord::Migration
  def up
    Page.load_unloaded
  end

  def down
  end
end
