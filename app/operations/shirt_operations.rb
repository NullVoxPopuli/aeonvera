module ShirtOperations
  class Create < SkinnyControllers::Operation::Base
    include LineItem::ShirtOperations::Helpers

    def run
      shirt = LineItem::Shirt.new(params_with_proper_sizing_metadata)
      return unless allowed_for?(shirt)

      shirt.save
      shirt
    end
  end

  class Update < SkinnyControllers::Operation::Base
    include LineItem::ShirtOperations::Helpers

    def run
      return unless allowed?
      model.update(params_with_proper_sizing_metadata)

      model
    end
  end
end