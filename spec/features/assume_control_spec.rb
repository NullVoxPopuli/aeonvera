# require 'spec_helper'
#
# describe "AssumeControl" do
#
#     describe '#assume_control' do
#       before(:each) do
#         user = create(:user, confirmed_at: Time.now, first_name: "original")
#         login_as(user, scope: :user)
#       end
#
#       after(:each) do
#         expect(page.current_url).to end_with('/')
#       end
#
#       it 'does not find the cache token' do
#         visit '/users/-1/assume_control'
#
#         expect(page).to have_content("User not found or token expired")
#       end
#
#       it 'cannot find the user (maybe due to deletion)' do
#         Cache.set('1', -1)
#         visit '/users/1/assume_control'
#
#         expect(page).to have_content("User not found.")
#       end
#
#       it 'signs the new user in' do
#         new_user = create(:user, confirmed_at: Time.now, first_name: "new_user")
#         Cache.set('1', new_user.id)
#
#         visit '/users/1/assume_control'
#         page!
#         expect(page).to have_content("new_user")
#       end
#
#       it 'tells us we are impersonating the user' do
#         new_user = create(:user, confirmed_at: Time.now, first_name: "new_user")
#         Cache.set('1', new_user.id)
#
#         visit '/users/1/assume_control'
#
#         expect(page).to have_content("You are now #{new_user.name}.")
#       end
#
#     end
#
# end
