# == Schema Information
#
# Table name: housing_provisions
#
#  id                         :integer          not null, primary key
#  housing_capacity           :integer
#  number_of_showers          :integer
#  can_provide_transportation :boolean          default(FALSE), not null
#  transportation_capacity    :integer          default(0), not null
#  preferred_gender_to_host   :string(255)
#  has_pets                   :boolean          default(FALSE), not null
#  smokes                     :boolean          default(FALSE), not null
#  notes                      :text
#  attendance_id              :integer
#  attendance_type            :string(255)
#  host_id                    :integer
#  host_type                  :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  name                       :string
#  deleted_at                 :datetime
#
# Indexes
#
#  index_housing_provisions_on_attendance_id_and_attendance_type  (attendance_id,attendance_type)
#  index_housing_provisions_on_host_id_and_host_type              (host_id,host_type)
#

require 'rails_helper'

RSpec.describe HousingProvision, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
