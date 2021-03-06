# frozen_string_literal: true

module Api
  # Used for searching for members to add to an organization.
  # Searches through all registered users
  #
  # The current user must supply an organization_id that they
  # manage to be able to to view this data
  class MembersController < ResourceController
    skinny_controllers_config model_class: User,
                              model_params_key: 'member',
                              association_name: 'members'

    self.serializer = MemberSerializableResource

    before_action :must_be_logged_in
    before_action :enforce_search_parameters, only: [:index]

    def index
      return all if params[:all]

      model = MemberOperations::ReadAll.new(current_user, params).run

      respond_to do |format|
        format.json { render_jsonapi(model: model) }
        format.csv { send_csv(model, serialize: false) }
      end
    end

    def all
      search = User.ransack(params[:q])
      render_jsonapi(model: search.result)
    end

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
