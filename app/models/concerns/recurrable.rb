module Recurrable
  extend ActiveSupport::Concern

  included do
    serialize :schedule, JSON
  end

  def schedule_to_words
    sched = read_schedule
    if sched
      IceCube::Rule.from_hash(sched).to_s
    end
  end

  private

  # now what do I do with it?
  def read_schedule
    sched = schedule == "null" ? nil : schedule
    if sched.is_a?(String)
      hash = JSON.parse(sched)
    end
  end
end
