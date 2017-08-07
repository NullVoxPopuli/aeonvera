# frozen_string_literal: true
module Api
  class OrganizationSummariesController < APIController
    self.serializer = OrganizationSummarySerializableResource

    include SetsOrganization

    def show
      render_jsonapi(model: @organization)
    end
  end
end
