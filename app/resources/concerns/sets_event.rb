# TODO: remove
module SetsEvent
  extend ActiveSupport::Concern

  include EventLoader

  included do
    before_action :set_event
    helper_method :current_event
  end
end
