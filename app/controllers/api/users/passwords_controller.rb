class Api::Users::PasswordsController < Devise::PasswordsController
  respond_to :html, :json

  prepend_before_filter :logout, only: :edit
  # skip_before_filter :require_no_authentication
  # skip_before_filter :verify_authenticity_token
  # skip_before_filter :authenticate_user_from_token
  # skip_before_filter :authenticate_user!
  # skip_before_filter :assert_reset_token_passed

  def edit
    # get out of the api path
    # TODO: use the below URL in the email and
    #       get rid of this action
    redirect_to edit_user_password_path(
      reset_password_token: params[:reset_password_token]
    )
  end

  private

  def resource_name
    :user
  end

  def logout
    (Devise.sign_out_all_scopes ? sign_out : sign_out(:user))
  end
end
