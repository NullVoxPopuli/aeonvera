# frozen_string_literal: true
module Api
  class RestraintPolicy < SkinnyControllers::Policy::Base
    def update?
      create?
    end

    def create?
      dependable = object.dependable
      restrictable = object.restrictable

      dep_host = dependable.try(:host) || dependable.try(:event)
      res_host = restrictable.try(:host) || restrictable.try(:event)

      dep_allowed = dep_host.is_accessible_to?(user)
      res_allowed = res_host.is_accessible_to?(user)

      dep_allowed && res_allowed
    end
  end
end
