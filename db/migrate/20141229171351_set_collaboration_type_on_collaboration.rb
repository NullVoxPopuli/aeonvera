class SetCollaborationTypeOnCollaboration < ActiveRecord::Migration
  def change
    Collaboration.update_all(collaborated_type: Event.name)
  end
end
