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

    def sync_form_and_model(form, model)
      form.sync

      form_errors = form.errors.messages
      return if form_errors.blank?

      form_errors.each do |field, errors|
        Array[*errors].each do |error|
          model.errors.add(field, error)
        end
      end
    end
  end
end
