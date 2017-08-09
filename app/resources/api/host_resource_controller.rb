# frozen_string_literal: true

module Api
  class HostResourceController < Api::ResourceController
    # Why is index allowed via no login?
    before_filter :must_be_logged_in, except: [:index]

    def index
      model = operation_class.new(current_user, params, index_params).run

      respond_to do |format|
        format.json { render_jsonapi(model: model) }
        format.csv { send_data CsvGeneration.model_to_csv(model, params[:fields]) }
      end
    end

    def show
      model = operation_class.new(current_user, params, show_params).run

      render_jsonapi(model: model)
    end

    protected

    def index_params
      return params if params[:filter]
      return params if
        params[:event_id] || params[:organization_id] || (params[:host_id] && params[:host_type])

      raise ActionController::ParameterMissing, 'event, organization, or host params missing.'
    end

    def show_params
      #   params.require(:event_id)
    end

    def create_params_with(attributes, host: true)
      # if host, require different part of the params
      if host
        host_relationship = params
                            .require(:data).require(:relationships)
                            .require(:host).require(:data).permit(:id, :type)

        # convert the type to ruby class
        # this is why conventions are important...
        ember_type = host_relationship[:type]
        klass = ember_type.singularize.classify

        attributes.merge(
          host_id: host_relationship[:id],
          host_type: klass
        )
      else
        event_relationship = params
                             .require(:data).require(:relationships)
                             .require(:event).require(:data).permit(:id)

        attributes.merge(event_id: event_relationship[:id])
      end
    end
  end
end
