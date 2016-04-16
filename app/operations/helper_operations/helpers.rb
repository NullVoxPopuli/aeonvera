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


    def railsify_types(hash)
      hash.each_with_object({}) do |(k,v), h|
        k_s = k.to_s
        if k_s.ends_with?('_type')
          h[k] = ember_type_to_rails(v)
        elsif k_s.ends_with?('_attributes')
          if v.is_a?(Array)
            h[k] = v.map{ |vh| railsify_types(vh) }
          else
            h[k] = railsify_types(v)
          end
        else
          h[k] = v
        end
      end
    end

    def ember_type_to_rails(key)
      key = key.singularize.camelize

      non_line_items = [
        MembershipDiscount.name, Package.name, Competition.name,
        Event.name, Organization.name]

      if !non_line_items.include?(key)
        key = key.include?("LineItem") ? key : "LineItem::#{key}"
      end
      key
    end

  end
end
