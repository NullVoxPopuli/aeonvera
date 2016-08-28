class OrderLineItemPolicy < SkinnyControllers::Policy::Base
  def read_all?
    order = object.first.order
    order.user_id == user.id ||
    order.host.is_accessible_to?(user)
  end

  def read?
    owner? || order.host.is_accessible_to?(user)
  end

  def update?
    # if an order's total is 0.0, than it's been auto-marked as paid
    # and can change in to a state where it can be paid (where the total is > 0)
    # TODO: I may want to use some sort of enum for payment status or something
    return false if paid?
    read?
  end

  def delete?
    return false if paid?
    read?
  end

  def create?
    return false if paid?
    read?
  end

  # Only owners and collaborators can set this
  def mark_as_picked_up?
    order.host.is_accessible_as_collaborator?(user)
  end

  private

  def paid?
    object.persisted? && order.paid?
  end

  def owner?
    order.user_id == user.id
  end

  def order
    @order ||= object.order
  end
end
