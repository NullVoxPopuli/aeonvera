# frozen_string_literal: true

module Api
  class EventPolicy < SkinnyControllers::Policy::Base
    include ::OwnershipChecks

    def read?(role = nil)
      return super unless role

      if role == Roles::ADMIN
        is_at_least_a_collaborator?(object)
      elsif role == Roles::COLLABORATOR
        is_at_least_a_collaborator?(object)
      end
    end

    class SubConfiguration < SkinnyControllers::Policy::Base
      include ::OwnershipChecks

      def read_all?
        return true if object.nil? || object.empty?
        super
      end

      def read?(o = object)
        parent(o).is_accessible_to? user
      end

      def update?
        is_at_least_a_collaborator?(parent)
      end

      def delete?
        is_owner?(parent)
      end

      def create?
        is_at_least_a_collaborator?(parent)
      end

      private

      def parent(o = object)
        o.try(:event) || o.try(:host)
      end
    end
  end
end
