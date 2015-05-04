require 'spec_helper'

describe "AssumeControl" do

    describe '#assume_control' do

      it 'does not find the cache token' do
        user = create(:user)
        user.confirmed_at = Time.now
        user.save
        login_as(user, scope: :user)

        visit '/users/-1/assume_control'

        expect(page).to have_content("User not found or token expired")
        expect(page.current_url).to end_with('/')
      end

      it 'cannot find the user (maybe due to deletion)' do

      end

      it 'signs the new user in' do

      end

      it 'tells us we are impersonating the user' do

      end

      it 'redirects to the root url upon success' do

      end

    end

end
