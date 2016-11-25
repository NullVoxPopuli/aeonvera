# frozen_string_literal: true
class Pass < ActiveRecord::Base
  belongs_to :event
  belongs_to :attendance

  belongs_to :discountable, polymorphic: true

  def discount_for
    discountable.try(:name)
  end

  def attendee_name
    attendance&.attendee_name
  end
end
