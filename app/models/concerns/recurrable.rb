# frozen_string_literal: true
module Recurrable
  extend ActiveSupport::Concern

  included do
    serialize :schedule, JSON
  end

  def schedule_to_words
    sched = read_schedule
    IceCube::Rule.from_hash(sched).to_s if sched
  end

  private

  # now what do I do with it?
  def read_schedule
    sched = schedule == 'null' ? nil : schedule
    hash = JSON.parse(sched) if sched.is_a?(String)
  end
end
