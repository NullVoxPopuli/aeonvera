# frozen_string_literal: true

module Api
  class OrganizationSummariesController < APIController
    self.serializer = OrganizationSummarySerializableResource

    include SetsOrganization

    def show
      model = OrganizationSummaryPresenter.new(@organization)

      render_jsonapi(model: model)
    end
  end
end
