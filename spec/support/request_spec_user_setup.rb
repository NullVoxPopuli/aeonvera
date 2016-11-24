module RequestSpecUserSetup
  extend ActiveSupport::Concern

  included do
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

    let(:set_login_header_as) do
      lambda do |user|
        @headers = { 'Authorization' => 'Bearer ' + user.authentication_token }
      end
    end
  end
end
