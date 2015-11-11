module Operations
  class LineItem::Read < Base
    def run
      model if allowed?
    end
  end
end
