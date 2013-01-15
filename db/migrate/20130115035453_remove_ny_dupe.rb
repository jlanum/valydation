class RemoveNyDupe < ActiveRecord::Migration
  def up
    City.where(:name => "New York").first.delete
  end

  def down
  end
end
