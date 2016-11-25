# == Schema Information
#
# Table name: competition_responses
#
#  attendance_id     :integer
#  competition_id    :integer
#  id                :integer          not null, primary key
#  dance_orientation :string(255)
#  partner_name      :string(255)
#  deleted_at        :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  attendance_type   :string(255)      default("EventAttendance")
#

require 'rails_helper'

RSpec.describe CompetitionResponse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
