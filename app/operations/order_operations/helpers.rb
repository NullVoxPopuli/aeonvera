module OrderOperations
  module Helpers

    def save_order
      ActiveRecord::Base.transaction do
        @model.save
        @model.line_items.map(&:save)
      end
    end

    def host_from_params
      id, host_type = params_for_action[:order].values_at(:hostId, :hostType)

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
