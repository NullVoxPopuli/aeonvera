# this is where collaborations are managed
# collaborations are accepted at users/collaborations
class Api::CollaborationsController < Api::ResourceController
  before_filter :must_be_logged_in


end
