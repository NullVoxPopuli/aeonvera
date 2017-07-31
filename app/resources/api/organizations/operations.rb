# frozen_string_literal: true
module Api
  module OrganizationOperations
    class Read < SkinnyControllers::Operation::Base
      def run
        model if allowed?
      end
    end
  end
end
