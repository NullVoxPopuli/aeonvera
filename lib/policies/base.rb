module Policies
  class Base
    attr_accessor :user, :object

    def initialize(user, object)
      self.user = user
      self.object = object
    end
  end
end
