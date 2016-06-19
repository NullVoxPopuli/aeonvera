class MembershipRenewal < ActiveRecord::Base
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
