module OrderLineItemOperations
  class Delete < SkinnyControllers::Operation::Base
    def run
      model.destroy
      model
    end

    def allowed_to_delete?

      allowed? || token_matches
    end
  end
end
