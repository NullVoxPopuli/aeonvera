# frozen_string_literal: true

module Controllers
  module CurrentUser
    extend ActiveSupport::Concern

    def current_user
      @current_user ||= authenticate_user_from_token!
      # binding.pry
      # unless @current_user
      #   ||= User.where(authentication_token: params[:auth_token]).first
      @current_user
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
end
