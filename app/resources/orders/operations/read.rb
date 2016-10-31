module OrderOperations
  class Read < SkinnyControllers::Operation::Base
    def run
      return model if allowed?
    end
  end
end
