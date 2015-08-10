class ApplicationController < ActionController::Base
  include CommonApplicationController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token


  before_filter :check_subdomain

  # optional
  before_action :authenticate_user_from_token!, except: [:sign_in, :sign_up, :assum_control]

  # regular auth method
  before_filter :authenticate_user!, except: [:sign_in, :sign_up, :assume_control]

  before_action :set_time_zone

  before_action :subdomain_failure?

  helper_method :current_domain

  # # Receives the redirect request from the admin Assume Control link.
  # def assume_control
  #   user_id = Cache.get(params[:token])
  #
  #   if user_id.blank?
  #     flash[:alert] = "User not found or token expired."
  #     return redirect_to(root_url)
  #   end
  #
  #   begin
  #     user = User.find(user_id)
  #   rescue => e
  #     flash[:alert] = "User not found."
  #     return redirect_to(root_url)
  #   end
  #
  #   sign_in(user, :bypass => true)
  #
  #   flash[:notice] = "You are now #{user.name}."
  #
  #   return redirect_to(root_url)
  # end

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

  # pulls all routes that are scoped to subdomains
  # @return [Array] list of routes defined on the subdomains
  def self.subdomain_routes
    @subdomain_routes ||= Rails.application.routes.routes.select{ |route|
      constraints = route.app.try(:constraints)
      constraints.try(:include?, Subdomain)
    }
  end

  private

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

end
