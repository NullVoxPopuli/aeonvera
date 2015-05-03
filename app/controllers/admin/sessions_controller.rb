class Admin::SessionsController < AdminController

  skip_before_filter :current_user, :only => [:authenticate, :failure]

  def authenticate
    # Restrict Admin access to specific domains.
    if (auth_hash["info"] && auth_hash["info"]["email"] &&
        auth_hash["info"]["email"].include?("aeonvera.com"))

      user = Admin::User.find_or_create_from_auth_hash(auth_hash)
      user = user.first if user.respond_to?(:first)
      if (uid = user.try(:uid)).present?
        cookies['_admin_token'] = Base64.strict_encode64(uid)
      else
        cookies['_admin_token'] = ''
      end
      return redirect_to '/'
    end

    redirect_to "//#{current_domain}"
  end

  def failure
    Rails.logger.error("Failed to authenticate Google OpenID: #{params[:message]}")
    redirect_to "//#{current_domain}"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
