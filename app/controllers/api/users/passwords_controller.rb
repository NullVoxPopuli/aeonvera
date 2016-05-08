class Api::Users::PasswordsController < Devise::PasswordsController
  # include DeviseOverrides
  respond_to :html, :json

  prepend_before_filter :logout, only: :edit
  # skip_before_filter :require_no_authentication
  # skip_before_filter :verify_authenticity_token
  # skip_before_filter :authenticate_user_from_token
  # skip_before_filter :authenticate_user!
  # skip_before_filter :assert_reset_token_passed

  private

  def resource_name
    :user
  end

  def logout
    (Devise.sign_out_all_scopes ? sign_out : sign_out(:user))
  end
end
