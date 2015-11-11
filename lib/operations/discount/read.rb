module Operations
  class Discount::Read < Base
    def run
      model if allowed?
    end
  end
end
