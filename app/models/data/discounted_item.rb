# == Schema Information
#
# Table name: discounted_items
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class DiscountedItem < ApplicationRecord
	belongs_to :discount
	belongs_to :attendee
end
