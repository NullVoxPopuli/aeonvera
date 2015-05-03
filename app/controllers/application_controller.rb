class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_subdomain
  before_filter :authenticate_user!, except: [:sign_in, :assume_control]

  before_action :set_time_zone

  before_action :subdomain_failure?

  helper_method :current_domain

  # Receives the redirect request from the admin Assume Control link.
  def assume_control
    user_id = Cache.get(params[:token])

    if user_id.blank?
      flash[:alert] = "User not found or token expired."
      return redirect_to(root_url)
    end

    begin
      user = User.find(user_id)
    rescue => e
      flash[:alert] = "User not found."
      return redirect_to(root_url)
    end

    sign_in(user, :bypass => true)

    flash[:notice] = "You are now #{user.name}."

    return redirect_to(root_url)
  end

  def back
    url = request.referer
    # ensure previous URL is not the current URL
    if url && url.include?(APPLICATION_CONFIG['domain'][Rails.env])
      url = url.gsub(/\/([^\/]+)\/?$/, '')
    end

    url = url || root_url
    # ensure route exists
    unless RouteRecognizer.is_route?(url)
      url = root_url
    end

    redirect_to url
  end


  protected

  def devise_parameter_sanitizer
    if resource_class == User
      UserParameterSanitizer.new(User, :user, params)
    else
      super
    end
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

  # pulls all routes that are scoped to subdomains
  # @return [Array] list of routes defined on the subdomains
  def self.subdomain_routes
    @subdomain_routes ||= Rails.application.routes.routes.select{ |route|
      constraints = route.app.try(:constraints)
      constraints.try(:include?, Subdomain)
    }
  end

  private

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

  def set_event
    id = (params[:hosted_event_id] or params[:id])
    begin
      @event = current_user.hosted_events.find(id)
    rescue ActiveRecord::RecordNotFound => e
      # user is not hosting the requested event
      begin
        @event = current_user.collaborated_events.find(id)
      rescue ActiveRecord::RecordNotFound => e
        # user has nothing to do with the requested event
        redirect_to action: "index"
      end
    end
  end

  # overrides devise hook
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # overrides devise hook
  def after_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # overrides devise hook
  def after_sign_out_path_for(resource)
    root_url
  end

  def current_domain
    APPLICATION_CONFIG[:domain][Rails.env]
  end
end
