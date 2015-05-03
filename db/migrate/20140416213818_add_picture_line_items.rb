class AddPictureLineItems < ActiveRecord::Migration
 def self.up
    add_attachment :line_items, :picture
  end

  def self.down
    remove_attachment :line_items, :picture
  end
end
