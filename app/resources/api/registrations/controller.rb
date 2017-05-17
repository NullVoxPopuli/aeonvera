# frozen_string_literal: true

module Api
  class RegistrationsController < UserResourceController
    self.resource_class = EventAttendance
    self.serializer_class = EventAttendanceSerializer
    self.parent_resource_method = :current_user
    self.association_name_for_parent_resource = :event_attendances

    def create
      model = resource_proxy.new(create_params)
      form = RegistrationForms::Create.new(model)
      valid = form.validate(create_params)
      ap form.errors
      ap valid
      ap form.sync
      ap model.errors.full_messages

      if valid && model.save
        render jsonapi: model, status: :created
      else
        render jsonapi: form.errors, status: :unprocessable_entity
      end
    end

    def resource_params
      whitelistable_params(polymorphic: [:host]) do |w|
        w.permit(
          :first_name, :last_name,
          :city, :state, :phone_number,
          :interested_in_volunteering,
          :dance_orientation,
          :host_id, :host_type
        )
      end
    end
  end
end
