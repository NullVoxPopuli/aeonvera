# frozen_string_literal: true

# == Schema Information
#
# Table name: membership_renewals
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  membership_option_id :integer
#  start_date           :datetime
#  deleted_at           :datetime
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_membership_renewals_on_membership_option_id              (membership_option_id)
#  index_membership_renewals_on_user_id                           (user_id)
#  index_membership_renewals_on_user_id_and_membership_option_id  (user_id,membership_option_id)
#

class MembershipRenewal < ApplicationRecord
  include SoftDeletable

  belongs_to :membership_option, class_name: LineItem::MembershipOption.name
  belongs_to :user

  validates :user, presence: true
  validates :membership_option, presence: true

  def expired?
    Time.now > expires_at
  end

  def expires_at
    start_date + duration
  end

  def duration
    membership_option.duration
  end
end
