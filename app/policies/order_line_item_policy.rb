class OrderLineItemPolicy < SkinnyControllers::Policy::Base
  def read?
    owner? || order.event.is_accessible_to?(user)
  end

  def update?
    return false if order.paid?
    read?
  end

  def delete?
    return false if order.paid?
    read?
  end

  def create?
    return false if order.paid?
    read?
  end

  private

  def owner?
    order.user_id == user.id
  end

  def order
    @order ||= object.order
  end
end
