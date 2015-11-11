module Operations
  class Order::Read < Base
    def run
      model if allowed?
    end
  end
end
