# These are membership renewals, so that we have access to the
# membership option, user, and expiration
class MembershipSerializer < ActiveModel::Serializer
  type 'memberships'
  attributes :id, :start_date, :expires_at, :expired, :duration

  belongs_to :membership_option
  class LineItem::MembershipOptionSerializer < LineItemSerializer
    type 'membership_options'
  end

  class MemberSerializer < ActiveModel::Serializer
    type 'members'
    attributes :id, :first_name, :last_name, :email
  end
  belongs_to :member, serializer: MemberSerializer

  def member
    object.user
  end

  # fake the id, since this is a join table
  def id
    "#{object.user_id}.#{object.membership_option_id}"
  end

  def expired
    object.expired?
  end
end
