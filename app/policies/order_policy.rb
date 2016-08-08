class OrderPolicy < SkinnyControllers::Policy::Base
  # A User should be able to:
  # - view all of their orders
  # - view all orders of an event they are helping organize
  # - view all orders of a community they help run
  # - TODO: view all orders of an event/community they collaborate on
  def read?(o = object)
    owner? || is_collaborator?
  end

  # This is allowed when:
  # - a user owns the order
  # - the unique unauth-token is present
  # - an event / organization is modifying the order
  #
  # I don't know if I want ordinary collaborators editing orders
  def update?
    # TODO: also check for unauth token
    owner? || is_collaborator?
  end

  def delete?
    !object.paid && (owner? || did_create?)
  end

  private

  def did_create?
    object.created_by_id == user_id
  end

  def owner?
    object.user_id == user_id
  end

  # this covers both event and community
  def is_from_an_owned_event?
    object.host.user.id == user_id
  end

  def is_collaborator?
    object.host.is_accessible_as_collaborator?(user)
  end

  def user_id
    user.is_a?(User) && user.id
  end
end
