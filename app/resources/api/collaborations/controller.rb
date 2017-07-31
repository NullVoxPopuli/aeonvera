# frozen_string_literal: true
# this is where collaborations are managed
# collaborations are accepted at users/collaborations
module Api
  class CollaborationsController < Api::ResourceController
    # include ::HelperOperations::Helpers
    # include ::SkinnyControllers::Diet

    # self.resource_class = ::Collaboration
    # self.serializer_class = CollaborationSerializer
    # self.parent_resource_method = :host
    # self.association_name_for_parent_resource = :collaborations
    #
    before_filter :must_be_logged_in
    #
    #
    # def accept_invitation
    #   model = operation_class.new(current_user, params).run
    #
    #   render_jsonapi(model)
    # end
    #
    # def index
    #   render_models(params[:include])
    # end
    #
    # def create
    #   model = operation_class.new(current_user, params, create_params).run
    #
    #   render_jsonapi_model(
    #     model,
    #     options: { status: :created })
    # end
    #
    # def update
    #   model = operation_class.new(current_user, params, update_params).run
    #
    #   render_jsonapi_model(model)
    # end
    #
    # def destroy
    #   render_model
    # end
    #
    # # used by superclass
    #
    # def host
    #   host_from_params(create_params)
    # end

    private

    def update_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(:role, :permissions)
      end
    end

    def create_params
      whitelistable_params(polymorphic: [:host]) do |whitelister|
        whitelister.permit(
          :email,
          :host_type, :host_id
        )
      end
    end

    alias update_collaboration_params update_params
    alias create_collaboration_params create_params
  end
end
