module Api
  module OrderLineItemOperations
    class Delete < SkinnyControllers::Operation::Base
      def run
        model.destroy
        model
      end

      # TODO: Is this used?
      def allowed_to_delete?
        allowed? || token_matches
      end
    end

    class MarkAsPickedUp < SkinnyControllers::Operation::Base
      def run
        return unless allowed?
        model.update(picked_up_at: Time.now)
        model
      end
    end
  end
end
