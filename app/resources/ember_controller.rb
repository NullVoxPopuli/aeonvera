# frozen_string_literal: true
# Main entry point to the app / ember
class EmberController < ActionController::Base
  def index
    # get ember from redis
    ember_index = APICache.store.get('aeonvera:index:current-content')

    raise StandardError, 'Ember not deployed!!!' unless ember_index

    render inline: ember_index
  end
end
