def login_as_confirmed_user(user = @user)
  user ||= create(:user)
  user.confirmed_at = Time.now
  user.save
  login_as(user, scope: :user)
  @user = user
end