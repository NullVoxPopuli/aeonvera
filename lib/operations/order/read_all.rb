module Operations
  class Order::ReadAll < Base
    def run
      model if allowed?
    end
  end

end
