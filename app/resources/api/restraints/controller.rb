# frozen_string_literal: true

module Api
  class RestraintsController < APIController
    include SkinnyControllers::Diet
    self.serializer = RestraintSerializableResource

    before_filter :must_be_logged_in

    def index
      render_jsonapi
    end

    def create
      render_jsonapi
    end

    def update
      render_jsonapi
    end

    def destroy
      render_jsonapi
    end

    private

    def update_restraint_params
      # can't update restriction_for (Discount),
      # because that workflow could get confusing
      ActiveModelSerializers::Deserialization.jsonapi_parse(
        params,
        only: [:restricted_to],
        polymorphic: [:restriction_for, :restricted_to]
      )
    end

    def create_restraint_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(
        params,
        polymorphic: [:restriction_for, :restricted_to]
      )
    end
  end
end
