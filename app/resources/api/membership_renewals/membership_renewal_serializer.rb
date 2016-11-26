# frozen_string_literal: true
module Api
  class MembershipRenewalSerializer < ActiveModel::Serializer
    type 'membership_renewals'

    attributes :id, :start_date, :expires_at, :expired, :duration, :_id

    class LineItem::MembershipOptionSerializer < Api::MembershipOptionSerializer
      type 'membership_options'
    end

    belongs_to :membership_option
    belongs_to :member, serializer: MemberSerializer

    def member
      object.user
    end

    # fake the id, since this is a join table
    # todo: why didn't I just make these relationships?
    def id
      "#{object.user_id}.#{object.membership_option_id}-#{object.created_at}"
    end

    def _id
      object.id
    end

    def expired
      object.expired?
    end
  end
end
