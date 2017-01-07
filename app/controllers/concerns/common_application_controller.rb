# frozen_string_literal: true
module CommonApplicationController
  extend ActiveSupport::Concern

  def current_user
    @current_user ||= authenticate_user_from_token!
    # binding.pry
    # unless @current_user
    #   ||= User.where(authentication_token: params[:auth_token]).first
    @current_user
  end

  def current_domain
    APPLICATION_CONFIG[:domain][Rails.env]
  end

  def subdomain_failure?
    flash[:alert] = 'Domain not found.' if params[:subdomain_failure]
  end

  def set_time_zone
    return unless current_user && current_user.time_zone.present?
    Time.zone = current_user.time_zone
  end

  def authenticate_user_from_token!
    http_authorization = request.env['HTTP_AUTHORIZATION']
    return false unless http_authorization
    matches = http_authorization.match(/Bearer (.+)\z/)
    return false unless matches
    token = matches[1]

    user = User.find_by_authentication_token(token)

    if user
      if !user.confirmed?
        user.errors.add(:base, I18n.t('devise.failure.unconfirmed'))
      else
        sign_in user, store: false
      end
    end

    user
  end
end
