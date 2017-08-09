# frozen_string_literal: true

module Api
  module Users
    class RegistrationsController < APIController
      include SkinnyControllers::Diet
      self.serializer = ::Api::Users::RegistrationSerializableResource
      self.default_include = { orders: [:order_line_items] }.freeze
      self.default_fields = {
        registration: Users::RegistrationSerializableResource::ATTRIBUTES,
        level: LevelFields::PUBLIC_ATTRIBUTES,
        order: OrderSerializableResource::BUYER_FIELDS,
        housing_request: [],
        housing_provision: HousingProvisionSerializableResource::PUBLIC_FIELDS,
        shirt: ShirtSerializableResource::PUBLIC_FIELDS,
        package: PackageSerializableResource::PUBLIC_FIELDS
      }.freeze

      before_filter :must_be_logged_in

      def create
        render_jsonapi(options: { include: 'housing_request,housing_provision,custom_field_responses' })
      end

      def update
        params[:fields] = { registration: {} }
        render_jsonapi(options: { include: 'housing_request,housing_provision,custom_field_responses' })
      end

      def index
        model = current_user
                .registrations
                .ransack(params[:q])
                .result

        render_jsonapi(model: model)
      end

      def show
        model = current_user
                .registrations
                .includes(orders: [:order_line_items])
                .find(params[:id])

        render_jsonapi(model: model)
      end

      def destroy
        @model = model

        head :no_content
      end

      private

      def resource_params
        whitelistable_params(polymorphic: [:host]) do |w|
          w.permit(
            :attendee_first_name, :attendee_last_name,
            :city, :state, :phone_number,
            :interested_in_volunteering,
            :dance_orientation,
            :host_id, :host_type,
            :level_id
          )
        end
      end
    end
  end
end
