require 'rails_helper'

describe Api::MembershipRenewalsController, type: :controller do
  describe 'create' do
    before(:each) do
      @organization = create(:organization)
      @user = create(:user)
      @membership_option = create(:membership_option, host: @organization)
      login_through_api(@user)
    end

    it 'creates a new membership renewal' do
      json_api = {
        data: {
          type: 'membership-renewals',
          attributes: {
            start_date: Time.now
          },
          relationships: {
            membership_option: {
              data: {
                id: @membership_option.id,
                type: 'membership-options'
              }
            },
            member: {
              data: {
                id: @user.id,
                type: 'members'
              }
            }
          }
        }
      }

      json_api_create_with(MembershipRenewal, json_api)
    end
  end
end
