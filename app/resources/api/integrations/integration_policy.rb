class IntegrationPolicy < SkinnyControllers::Policy::Base
  def read?
    owner?
  end

  # there is no updating of integrations
  # only deleting, and creating a new one
  def update?; false; end

  def delete?
    owner?
  end

  def create?
    owner?
  end

  private

  def owner?
    object.owner.user.id == user.id
  end

end
