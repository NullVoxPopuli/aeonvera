module OrderOperations
  module Helpers

    def attendance_params
      params_from_deserialization[:attendance_attributes]
    end

    def order_line_items_params
      params_from_deserialization[:order_line_items_attributes]
    end

    def housing_request_params
      attendance_params[:housing_request_attributes]
    end

    def housing_provision_params
      attendance_params[:housing_provision_attributes]
    end

    def order_params
      params_from_deserialization
    end

    def package_id_from_data
      order_line_items_params.each do |item|
        if item[:line_item_type] == Package.name
          return item[:line_item_id]
        end
      end
      return nil
    end

    def deserialized_params
      @deserialized_params ||= ActiveModelSerializers::Deserialization.jsonapi_parse(
        params,
        embedded: [
          :order_line_items,
          :attendance,
          :housing_request,
          :housing_provision
        ],
        polymorphic: [:line_item, :host])
    end

    def params_from_deserialization
      @railsified ||= railsify_types(deserialized_params)
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


    def save_order
      ActiveRecord::Base.transaction do
        @model.save
        @model.line_items.map(&:save)
      end
    end

    def host_from_params
      id, host_type = params_for_action[:order].values_at(:host_id, :host_type)

      if host_type.downcase.include?('organization')
        Organization.find(id)
      else
        Event.find(id)
      end
    end

    def params_for_order
      # fake strong parameters
      @params_for_order ||= params_for_action[:order].select do |k, v|
        [
          :attendance_id, :host_id, :host_type,
          :payment_method,
          # from ember / the crappy ajax
          :userEmail, :userName, :hostId, :hostType
        ].include?(k.to_sym)
      end
    end

    def params_for_items
      @params_for_items ||= params_for_action[:orderLineItems].values
    end
  end
end
