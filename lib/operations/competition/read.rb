module Operations
  class Competition::Read < Base
    def run
      model if allowed?
    end
  end
end
