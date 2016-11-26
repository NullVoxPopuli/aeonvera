# frozen_string_literal: true
module MemberOperations
  class ReadAll < SkinnyControllers::Operation::Default
    def run
      return super unless params[:format] == 'csv'
      data_for_csv
    end

    def data_for_csv
      org = Organization.find(params[:organization_id])
      members = org.members

      @model = members.map do |member|
        {
          first_name: member.first_name,
          last_name: member.last_name,
          email: member.email,
          is_active_member: member.is_member_of?(org),
          member_since: member.member_since(org),
          membership_expires_at: member.membership_expires_at(org).iso8601
        }
      end
    end
  end
end
