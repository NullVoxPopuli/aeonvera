module HelperOperations
  module Helpers
    def host_from_params(params)
      id, host_type = params.values_at(:host_id, :host_type)

      if host_type.downcase.include?('organization')
        Organization.find(id)
      else
        Event.find(id)
      end
    end

    def jsonapi_parse(*args)
      ActiveModelSerializers::Deserialization.jsonapi_parse(*args)
    end
  end
end
