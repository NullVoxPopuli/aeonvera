# frozen_string_literal: true
module Api
  module ShirtOperations
    class Create < SkinnyControllers::Operation::Base
      include ShirtOperations::Helpers

      def run
        shirt = Shirt.new(params_with_proper_sizing_metadata)
        return unless allowed_for?(shirt)

        shirt.save
        shirt
      end
    end

    class Update < SkinnyControllers::Operation::Base
      include ShirtOperations::Helpers

      def run
        return unless allowed?
        model.update(params_with_proper_sizing_metadata)

        model
      end
    end
  end
end
