module Api
  module OrderOperations
    class Read < SkinnyControllers::Operation::Base
      def run
        model if allowed?
      end
    end
  end
end
