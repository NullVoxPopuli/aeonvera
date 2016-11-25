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
#  attendance_id     :integer
#  event_id          :integer
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Pass do
  pending "add some examples to (or delete) #{__FILE__}"
end
