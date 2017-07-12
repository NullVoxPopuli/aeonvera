# frozen_string_literal: true
module HelperOperations
  module Helpers
    def host_from_params(params)
      id, host_type = params.values_at(:host_id, :host_type)

      if host_type&.downcase&.include?('organization')
        Organization.find(id)
      else
        Event.find(id)
      end
    end
  end
end
