class DiscountedItem < ActiveRecord::Base
	belongs_to :discount
	belongs_to :attendee
end
