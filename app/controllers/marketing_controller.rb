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
    domain = APPLICATION_CONFIG['domain'][Rails.env]
    url = request.url
    protocol, url = request.url.split('://')
    subdomain = url.sub('.' + domain, '').sub('/', '')

    if subdomain != 'www'
      redirect_to "#{protocol}://#{domain}/#{subdomain}/"
    end
  end

end
