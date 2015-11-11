module Operations
  class Package::Read < Base
    def run
      model if allowed?
    end
  end
end
