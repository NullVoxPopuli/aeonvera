# frozen_string_literal: true
module Api
  class MemberSerializer < ActiveModel::Serializer
    type 'members'

    attributes :id, :first_name, :last_name, :email

    # Requires context of organization
    # Maybe use an array of hashes?
    #
    # class CSVSerializer < ActiveModel::Serializer
    #   type 'members'
    #
    #   attributes :first_name, :last_name,
    #     :email, :is_active_member,
    #     :member_since, :membership_expires_at
    #
    #   def is_active_member
    #     object.is_active_member
    #   end
    #
    # end
  end
end
