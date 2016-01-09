def login_as_confirmed_user(user = @user)
  user ||= create(:user)
  user.confirmed_at = Time.now
  user.save
  login_as(user, scope: :user)
  @user = user
end

def login_through_api(user = @user)
  user ||= create(:user)
  user.confirmed_at = 2.days.ago
  user.save
  @user = user

  # Authorization and Accept grabbed from Ember
  request.headers["Authorization"] = "Token token=\"#{user.authentication_token}\", email=\"#{user.email}\""
  request.headers['ACCEPT'] = 'application/vnd.api+json'
  #request.headers['Content-Type'] = 'application/vnd.api+json'
end
