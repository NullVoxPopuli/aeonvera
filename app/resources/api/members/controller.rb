# frozen_string_literal: true
module Api
  class MembersController < ResourceController
    self.model_class = User
    self.model_key = 'member'
    self.association_name = 'members'
    self.serializer = MemberSerializer

    before_action :must_be_logged_in
    before_action :enforce_search_parameters, only: [:index]

    private

    def enforce_search_parameters
      params[:q] ||= {}
      params[:q][:confirmed_at_not_null] = true
    end

    def index_member_params
      params.require(:organization_id)
      params
    end
  end
end
