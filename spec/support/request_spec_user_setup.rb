# frozen_string_literal: true
module RequestSpecUserSetup
  extend ActiveSupport::Concern

  included do
    let(:user) { create_confirmed_user }
    let(:stray_user) { create_confirmed_user }
    let(:owner) { create_confirmed_user }

    let(:organization) { create(:organization, owner: owner) }
    let(:event) { create(:event, hosted_by: owner) }
    let(:event_collaborator) do
      user = create_confirmed_user
      event.collaborators << user
      event.save
      user
    end
    let(:organization_collaborator) do
      user = create_confirmed_user
      organization.collaborators << user
      organization.save
      user
    end

    let(:set_login_header_as) do
      lambda do |user|
        @headers = { 'Authorization' => 'Bearer ' + user.authentication_token }
      end
    end

    before(:each) do
      host! APPLICATION_CONFIG[:domain][Rails.env]
    end
  end

  def auth_header_for(user)
    @headers = {
      'Authorization' => 'Bearer ' + user.authentication_token,
      # 'Accept'        => 'application/vnd.api+json',
      # 'Content-Type'  => 'application/vnd.api+json'
    }
  end
end
