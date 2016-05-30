# Main entry point to the app / ember
class MarketingController < ActionController::Base
  before_action :set_x_frame_options

  def index
    # get ember from redis
    ember_index = APICache.store.get('aeonvera:index:current-content')

    raise StandardError, 'Ember not deployed!!!' unless ember_index

    render inline: ember_index
  end

  private

  def set_x_frame_options
    # somewhat mitigate X-FRAME-OPTIONS weirdness
    if request.path.include?('/embed/')
      response.header['X-Frame-Options'] = 'ALLOW-FROM *'
    end
  end
end
