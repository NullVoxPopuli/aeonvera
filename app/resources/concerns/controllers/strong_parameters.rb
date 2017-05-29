# frozen_string_literal: true
module Controllers
  module StrongParameters
    protected

    def deserialize_params(polymorphic: [], embedded: [])
      ActiveModelSerializers::Deserialization
        .jsonapi_parse(params, embedded: embedded, polymorphic: polymorphic)
    end

    # wrapper around normal strong parameters that includes Deserialization
    # for JSON API parameters.
    # all parameters hitting this controller should be JSON API formatted.
    #
    # example:
    # whitelistable_params do |whitelister|
    #   whitelister.permit(:name, :price)
    # end
    def whitelistable_params(polymorphic: [], embedded: [])
      deserialized = deserialize_params(
        polymorphic: polymorphic,
        embedded: embedded
      )

      whitelister = ActionController::Parameters.new(deserialized)
      whitelister = yield(whitelister) if block_given?

      EmberTypeInflector.to_rails(whitelister)
    end
  end
end
