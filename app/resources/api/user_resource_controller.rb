# frozen_string_literal: true

module Api
  # Example Usage:
  #
  # module Api
  #   class RegistrationsController < UserResourceController
  #     self.resource_class = Attendance
  #     self.serializer_class = RegistrationSummarySerializer
  #     self.parent_resource_method = :current_user
  #     self.association_name_for_parent_resource = :registrations
  #
  #     def index
  #       search = current_user.attendances.ransack(params[:q])
  #       @attendances = search.result
  #
  #       render json: @attendances,
  #              include: params[:include],
  #              each_serializer: RegistrationSummarySerializer
  #     end
  #
  #     # create, new, update, delete, and show are inherited
  #
  #     def show
  #       @attendance = current_user.attendances.find(params[:id])
  #       render json: @attendance
  #     end
  #
  #     def resource_params; end
  #   end
  # end
  #
  # NOTE: there are callbacks provided:
  #       - before_create
  #       - before_update
  #       - before_destroy
  #       error handling / control flow rejecting is up to the implementation
  #       of these hooks. It's recommended to raise an exception.
  class UserResourceController < ::APIController
    # A Class Inheriting from this class must set resource_class
    # e.g.: self.resource_class = ::StepDefinitions::CoachingLoopStep
    class << self
      attr_accessor :resource_class

      # Optionally, set this, and instead of directly calling resource_class to CRUD,
      # the association on the object returned from this method will be used to CRUD
      attr_accessor :parent_resource_method

      # Optionally, set this to explicitly set the serializer to use for rendering
      attr_accessor :serializer_class

      # if the parent resource method has multiple relationships to a class,
      # this'll be required for retrieving the correct association.
      attr_accessor :association_name_for_parent_resource
    end

    def index
      search = resource_proxy.ransack(params[:q])
      results = search.result

      render_jsonapi_collection(results)
    end

    def show
      model = resource_proxy.find(params[:id])
      render_jsonapi(model)
    end

    def create(model = nil)
      model ||= resource_proxy.new(create_params)

      result = run_callbacks_for(:create, model) { model.save }

      if result
        render_jsonapi(model, status: :created)
      else
        render jsonapi: model.errors, status: :unprocessable_entity
      end
    end

    def update
      model = resource_proxy.find(params[:id])

      result = run_callbacks_for(:update, model) do
        model.update(update_params)
      end

      if result
        render_jsonapi(model)
      else
        render jsonapi: model.errors, status: :unprocessable_entity
      end
    end

    def destroy
      model = resource_proxy.find(params[:id])

      run_callbacks_for(:destroy, model) { model.destroy }

      head :no_content
    end

    protected

    def render_jsonapi(model, options = {})
      render_options = { jsonapi: model, include: params[:include] }

      render_options[:serializer] = serializer_class if serializer_class

      render(render_options.merge(options))
    end

    def render_jsonapi_collection(results, options = {})
      render_options = { jsonapi: results, include: params[:include] }

      render_options[:each_serializer] = serializer_class if serializer_class

      render(render_options.merge(options))
    end

    def run_callbacks_for(action_name, model)
      before_name = "before_#{action_name}"
      send(before_name, model) if respond_to?(before_name)

      yield
    end

    def update_params
      resource_params
    end

    def create_params
      resource_params
    end

    def resource_params
      raise 'resource_params or (update_params and create_params) must be overridden'
    end

    def resource_class
      self.class.resource_class || (raise "resource_class must be defined in #{self.class.name}")
    end

    def parent_resource_method
      self.class.parent_resource_method
    end

    def serializer_class
      self.class.serializer_class
    end

    def association_name_for_parent_resource
      self.class.association_name_for_parent_resource
    end

    private

    def resource_proxy
      @resource_proxy ||= begin
        determined_resource = _determine_resource

        # if params[:include]
        #   preloaded = JSONAPI::IncludeDirective.new(
        #     params[:include],
        #     allow_wildcard: true
        #   )
        #   ap preloaded
        #   determined_resource.preload(preloaded)
        # end

        determined_resource
      end
    end

    def _determine_resource
      # parent resource not defined, use resource_class
      return resource_class unless parent_resource_method

      # parent_resource_method doesn't exist, use resource_class
      return resource_class unless respond_to?(parent_resource_method)

      return _parent_object.send(association_name_for_parent_resource) if _use_association_name?

      if association_name_for_parent_resource
        raise "\
          association_name_for_parent_resource specified, but #{parent_resource_method}\
          does not respond_to? #{association_name_for_parent_resource}"
      end

      # use the resource_class to determine the association name
      association_name = _association_name_for(_parent_object)

      _parent_object.send(association_name)
    end

    def _parent_object
      # eval the parent_resource_method
      @_parent_object ||= send(parent_resource_method)
    end

    def _use_association_name?
      association_name_for_parent_resource &&
        _parent_object.respond_to?(association_name_for_parent_resource)
    end

    def _association_name_for(parent_object)
      # use the resource_class to determine the association name
      # Rails 5
      # association_name = parent_object
      #                    .reflect_on_all_associations
      #                    .select { |a| a.klass == resource_class }
      #                    .first.name
      #
      # # TODO: maybe specify relationship name? and filter on that instead?
      # #       - this would be required if there are multiple relationships with the same class

      # Rails 4
      parent_object
        ._reflections.map { |r| r[1] } # yay private methods
        .select { |r| r.klass == resource_class }
        .first.name
    end
  end
end
