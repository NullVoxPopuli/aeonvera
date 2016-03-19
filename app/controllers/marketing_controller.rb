class MarketingController < ActionController::Base
  def index
    # get ember from redis
    ember_index = APICache.store.get('aeonvera:index:current-content')

    unless ember_index
      raise StandardError.new("Ember not deployed!!!")
    end

    render inline: ember_index
  end


end
