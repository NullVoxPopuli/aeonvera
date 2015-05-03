class Collaboration < ActiveRecord::Base
  include SoftDeletable
  serialize :permissions, JSON


  belongs_to :collaborated, polymorphic: true
  belongs_to :user

  after_initialize :update_permissions

  private

  def update_permissions
    # initialize
    self.permissions ||= {}
  end

end
