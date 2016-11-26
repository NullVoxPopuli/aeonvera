module Api
  class MemberPolicy < SkinnyControllers::Policy::Base
    def read_all?
      user.organizations.present?
    end
  end
end
