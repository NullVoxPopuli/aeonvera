# frozen_string_literal: true

# == Schema Information
#
# Table name: passes
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  intended_for      :string(255)
#  percent_off       :integer
#  discountable_id   :integer
#  discountable_type :string(255)
#  registration_id     :integer
#  event_id          :integer
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Pass < ApplicationRecord
  belongs_to :event
  belongs_to :registration

  belongs_to :discountable, polymorphic: true

  def discount_for
    discountable.try(:name)
  end

  def attendee_name
    registration&.attendee_name
  end
end
