class MarketingController < ActionController::Base
  def index
    # get ember from redis
    ember_index = APICache.store.get('aeonvera:index:default')

    unless ember_index
      puts 'Keys in the store:'
      puts APICache.store.keys
      raise StandardError.new("Ember not deployed!!!")
    end

    render inline: ember_index
  end


end
