module Api
  class IntegrationsController < Api::ResourceController
    private

    def deserialized_params
      ActiveModelSerializers::Deserialization
        .jsonapi_parse(params, polymorphic: [:owner])
    end

    def create_integration_params
      whitelister = ActionController::Parameters.new(deserialized_params)
      whitelisted = whitelister.permit(
        :authorization_code, :kind, :owner_id, :owner_type)

      type = whitelisted[:owner_type]
      type = type.include?('event') ? 'Event' : 'Organization'
      whitelisted.merge(owner_type: type)
    end
  end
end
