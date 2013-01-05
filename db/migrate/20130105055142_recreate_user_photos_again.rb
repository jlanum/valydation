class RecreateUserPhotosAgain < ActiveRecord::Migration
  def up
    User.all.each do |u|
      begin
        puts "user: #{u.id}"
        u.photo.recreate_versions!
      rescue
        puts "error"
      end
    end
  end

  def down
  end
end
