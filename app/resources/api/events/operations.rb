# frozen_string_literal: true

module Api
  module EventOperations
    class Read < SkinnyControllers::Operation::Base
      def run
        model if allowed?
      end
    end

    class Create < SkinnyControllers::Operation::Base
      def run
        @model = model_class.new(model_params)
        # when wouldn't create an event be allowed?
        # return unless allowed?
        @model.hosted_by = current_user
        @model.opening_tier&.event = @model
        @model.save
        @model
      end
    end
  end
end
