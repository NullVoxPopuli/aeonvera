# frozen_string_literal: true
module Api
  class MembershipRenewalSerializer < ActiveModel::Serializer
    type 'membership_renewals'

    attributes :id, :start_date, :expires_at, :expired, :duration

    class LineItem::MembershipOptionSerializer < Api::MembershipOptionSerializer
      type 'membership_options'
    end

    belongs_to :membership_option, serializer: LineItem::MembershipOptionSerializer
    belongs_to :member, serializer: MemberSerializer

    def member
      object.user
    end

    def expired
      object.expired?
    end
  end
end
