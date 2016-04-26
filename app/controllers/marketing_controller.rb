class MarketingController < ActionController::Base
  def index
    # get ember from redis
    ember_index = APICache.store.get('aeonvera:index:current-content')

    raise StandardError.new('Ember not deployed!!!') unless ember_index

    render inline: ember_index
  end
end
