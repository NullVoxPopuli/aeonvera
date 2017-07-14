# this is where collaborations are managed
# collaborations are accepted at users/collaborations
module Api
  class CollaborationsController < UserResourceController
    include ::HelperOperations::Helpers

    self.resource_class = ::Collaboration
    self.serializer_class = CollaborationSerializer
    self.parent_resource_method = :host
    self.association_name_for_parent_resource = :collaborations

    before_filter :must_be_logged_in

    def host
      host_from_params(params)
    end

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
end
