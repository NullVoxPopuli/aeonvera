# frozen_string_literal: true
module Api
  # Used for searching for members to add to an organization.
  # Searches through all registered users
  #
  # The current user must supply an organization_id that they
  # manage to be able to to view this data
  class MembersController < ResourceController
    self.model_class = User
    self.model_key = 'member'
    self.association_name = 'members'
    self.serializer = MemberSerializer

    before_action :must_be_logged_in
    before_action :enforce_search_parameters, only: [:index]

    def index
      return all if params[:all]

      model = MemberOperations::ReadAll.new(current_user, params).run
      respond_to do |format|
        format.json { render_models }
        format.csv do
          csv_data = CsvGeneration.model_to_csv(
            model, params[:fields],
            skip_serialization: true
          )

          send_data(csv_data)
        end
      end
    end

    def all
      search = User.ransack(params[:q])
      render json: search.result, each_serializer: MemberSerializer
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
