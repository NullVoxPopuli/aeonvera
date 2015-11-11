module Operations
  class Event::Read < Base
    def run
      model if allowed?
    end
  end
end
