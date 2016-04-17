class Api::IntegrationsController < Api::ResourceController
  private

  def create_integration_params
    attributes = ActiveModelSerializers::Deserialization
      .jsonapi_parse(
        params,
        only: [
          :authorization_code, :kind, :owner
        ],
        polymorphic: [:owner]
      )


    type = attributes[:owner_type]
    type = type.include?('event') ? 'Event' : 'Organization'
    attributes.merge(owner_type: type)
  end
end
