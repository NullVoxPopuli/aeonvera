module CommonApplicationController
  extend ActiveSupport::Concern


  # @return [Array] list of allowed controllers on the subdomains
  def self.subdomain_controllers
    unless @subdomain_controllers
      allowed_controllers = subdomain_routes.map{ |route|
        route.defaults[:controller]
      }.uniq
      allowed_controllers += [
        "devise/sessions",
        "devise/passwords",
        "devise/unlocks",
        "devise/registrations"
      ]

      @subdomain_controllers = allowed_controllers
    end
    @subdomain_controllers
  end

  # subdomains are only allowed when registering for an event
  # or viewing an organization
  def check_subdomain
    https_domain = Rails.env.production? ? 'aeonvera.herokuapp.com' : 'aeonvera.fakeheroku.com'

    request_path = request.host_with_port
    subdomain = request.subdomain.split(".").first

    if Subdomain.matches?(request)

      # subdomain is not restricted, but lets see if the
      # requested path does not belong to the subdomain
      # todo - non events and events have a home controller,
      # how do we differentiate between them?
      if !self.class.subdomain_controllers.include?(params[:controller])
        return drop_subdomain_and_redirect
      end

      if Subdomain.is_event?(subdomain)

        # why does this check need to be here?
        is_not_subdomainless_controller = (
          params[:controller] != "register" &&
          !params[:controller].include?("devise") &&
          !params[:controller].include?("payment")
        )

        if is_not_subdomainless_controller
          return drop_subdomain_and_redirect
        end
      elsif Subdomain.is_organization?(subdomain)
        # do nothing, we're good
      else
        # where do we go?!?!?!?
        return drop_subdomain_and_redirect
        # we go home.
      end
    end

  end


  # if we end up on a subdomain URL that we aren't supposed to be on,
  # this drops the subdomain, and redirects to the root path of the
  # subdomainless path, maintaining all of the parameters
  def drop_subdomain_and_redirect
    # removes the bottomest subdomain
    new_path = request.host_with_port.split(".").drop(1).join(".")

    # pass along the params
    params.delete(:controller)
    params.delete(:action)
    return redirect_to "#{request.protocol}#{new_path}#{request.fullpath}?#{params.to_param}"
  end



  def current_domain
    APPLICATION_CONFIG[:domain][Rails.env]
  end

  def subdomain_failure?
    if params[:subdomain_failure]
      flash[:alert] = 'Domain not found.'
    end
  end


  def set_time_zone
    if current_user && current_user.time_zone.present?
      Time.zone = current_user.time_zone
    end
  end


  def authenticate_user_from_token!
    authenticate_with_http_token do |token, options|
      user_email = options[:email].presence
      user = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      end
    end
  end

end
