class MarketingController < ActionController::Base
  before_action :redirect_if_subdomain

  def index
    # get ember from redis
    ember_index = APICache.store.get('aeonvera:index:current-content')

    raise StandardError.new('Ember not deployed!!!') unless ember_index

    render inline: ember_index
  end

  private

  def redirect_if_subdomain
    unless request.subdomain.include? 'www'
      redirect_to redirect_url_for(request.url)
    end
  end

  def current_domain
    APPLICATION_CONFIG['domain'][Rails.env]
  end

  def redirect_url_for(url, domain = current_domain)
    protocol, url = url.split('://')
    subdomain, path = url.split('.' + domain)
    "#{protocol}://#{domain}/#{subdomain}/"
  end

end
