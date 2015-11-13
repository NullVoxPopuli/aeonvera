module Policies
  class Base
    attr_accessor :user, :object, :authorized_via_parent

    def initialize(user, object, authorized_via_parent: false)
      self.user = user
      self.object = object
      self.authorized_via_parent = authorized_via_parent
    end
  end
end
