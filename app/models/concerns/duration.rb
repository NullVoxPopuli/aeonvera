# frozen_string_literal: true

module Duration
  extend ActiveSupport::Concern

  DURATION_DAY = 0
  DURATION_WEEK = 1
  DURATION_MONTH = 2
  DURATION_YEAR = 3

  DURATIONS = [
    DURATION_DAY,
    DURATION_WEEK,
    DURATION_MONTH,
    DURATION_YEAR
  ].freeze

  DURATION_NAMES = {
    DURATION_DAY => 'Day',
    DURATION_WEEK => 'Week',
    DURATION_MONTH => 'Month',
    DURATION_YEAR => 'Year'
  }.freeze

  def duration
    unit_method = DURATION_NAMES[duration_unit].downcase.pluralize
    duration_amount.send(unit_method)
  end

  def duration_in_words
    "#{duration_amount} #{DURATION_NAMES[duration_unit]}"
  end
end
