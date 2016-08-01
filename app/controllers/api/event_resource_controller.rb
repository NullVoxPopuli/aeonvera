class Api::EventResourceController < Api::ResourceController
  before_filter :must_be_logged_in, except: [:index]

  def index
    # TODO: integrate skinny_controllers with ransack to reduce queries?
    model = operation_class.new(current_user, params, index_params).run

    respond_to do |format|
      format.json { render json: model, include: params[:include] }
      format.csv { send_data csv }
    end
  end

  def show
    model = operation_class.new(current_user, params, show_params).run
    render json: model, include: params[:include]
  end

  private

  def index_params
    params[:filter] ? params : params.require(:event_id)
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
        host_type: klass)
    else
      event_relationship = params
        .require(:data).require(:relationships)
        .require(:event).require(:data).permit(:id)

      attributes.merge(event_id: event_relationship[:id])
    end
  end


  protected

  def csv
    options = { adapter: :attributes }
    if params[:fields]
      fields = JSONAPI::IncludeDirective.new(params[:fields]).to_hash
      options[:fields] = ActiveModelSerializers::KeyTransform.underscore(fields)
    end
    hash = ActiveModelSerializers::SerializableResource.new(model, options).as_json

    hash = flat_hash(hash)
    CsvGeneration.models_to_csv(hash)
  end


  def flat_hash(hash)
    return hash.map{|h| flat_hash(h)} if hash.is_a?(Array)
    result = {}
    hash.each do |k, v|
      if v.is_a?(Hash)
        result.merge!(v)
      else
        result[k] = v
      end
    end
    result
  end
end
