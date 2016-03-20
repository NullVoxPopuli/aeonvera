class OrderPolicy < SkinnyControllers::Policy::Base
  # A User should be able to:
  # - view all of their orders
  # - view all orders of an event they are helping organize
  # - view all orders of a community they help run
  # - TODO: view all orders of an event/community they collaborate on
  def read?(o = object)
    owner? || is_from_an_owned_event?
  end

  private

  def owner?
    object.user_id == user.id
  end

  # this covers both event and community
  def is_from_an_owned_event?
    object.host.user.id == user.id
  end

end
