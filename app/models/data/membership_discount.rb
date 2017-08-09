# frozen_string_literal: true

# == Schema Information
#
# Table name: discounts
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  value                  :decimal(, )
#  kind                   :integer
#  disabled               :boolean          default(FALSE)
#  affects                :string(255)
#  host_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  deleted_at             :datetime
#  allowed_number_of_uses :integer
#  host_type              :string(255)
#  discount_type          :string(255)
#  requires_student_id    :boolean          default(FALSE)
#
# Indexes
#
#  index_discounts_on_host_id_and_host_type  (host_id,host_type)
#

class MembershipDiscount < Discount
  belongs_to :organization, class_name: Organization.name,
                            foreign_key: 'host_id', foreign_type: 'host_type', polymorphic: true
end
