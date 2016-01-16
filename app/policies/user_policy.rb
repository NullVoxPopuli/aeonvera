class UserPolicy < SkinnyControllers::Policy::Base

  def read?; is_current_user?; end
  def update?; is_current_user?; end
  def delete?; is_current_user?; end
  def create?; true; end

  private

  def is_current_user?
    object == user
  end
end
