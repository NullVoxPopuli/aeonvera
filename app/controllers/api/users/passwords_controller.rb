class Api::Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  skip_before_filter :require_no_authentication
end
