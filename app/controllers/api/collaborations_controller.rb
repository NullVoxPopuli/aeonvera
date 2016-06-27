# this is where collaborations are managed
# collaborations are accepted at users/collaborations
class Api::CollaborationsController < Api::ResourceController
  before_filter :must_be_logged_in

  private

  def update_collaboration_params
    whitelistable_params(polymorphic: [:host]) do |whitelister|
      whitelister.permit(
        :role, :permissions)
    end
  end

  def create_collaboration_params
    whitelistable_params(polymorphic: [:host]) do |whitelister|
      whitelister.permit(
        :email,
        :host_type, :host_id
      )
    end
  end
end
