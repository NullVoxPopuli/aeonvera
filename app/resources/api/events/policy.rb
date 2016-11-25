module Api
  class EventPolicy < SkinnyControllers::Policy::Base
    class SubConfiguration < SkinnyControllers::Policy::Base
      include ::OwnershipChecks

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
