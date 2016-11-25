module Api
  class HostPolicy < SkinnyControllers::Policy::Base
    def read?
      return true unless is_event?

      # An event cannot be accessed AT ALL
      # if the event has ended.
      # This is to free up the namespace for other events
      # that might want to use the same name. (That's probably a
      # poor marketing decision though -- but not our problem)
      !has_ended?
    end

    def is_event?
      object.class == Event
    end

    def has_ended?
      object.ends_at < Time.now
    end

  end
end
