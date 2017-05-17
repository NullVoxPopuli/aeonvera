# frozen_string_literal: true

module Api
  # Example Usage:
  #
  # module Api
  #   class RegistrationsController < UserResourceController
  #     self.resource_class = Attendance
  #     self.serializer_class = RegistrationSummarySerializer
  #     self.parent_resource_method = :current_user
  #     self.association_name_for_parent_resource = :attendances
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

      render jsonapi: results, include: params[:include]
    end

    def show
      render jsonapi: resource_proxy.find(params[:id]), include: params[:include]
    end

    def create
      model = resource_proxy.new(create_params)
      if model.save
        render jsonapi: model, status: :created
      else
        render jsonapi: model.errors, status: :unprocessable_entity
      end
    end

    def update
      model = resource_proxy.find(params[:id])

      if model.update(update_params)
        render jsonapi: model
      else
        render jsonapi: model.errors, status: :unprocessable_entity
      end
    end

    def destroy
      model = resource_proxy.find(params[:id])
      model.destroy

      head :no_content
    end

    protected

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
        # parent resource not defined, use resource_class
        return resource_class unless parent_resource_method

        # parent_resource_method doesn't exist, use resource_class
        return resource_class unless respond_to?(parent_resource_method)

        # eval the parent_resource_method
        parent_object = send(parent_resource_method)

        use_association_name = association_name_for_parent_resource &&
          parent_object.respond_to?(association_name_for_parent_resource)

        return parent_object.send(association_name_for_parent_resource) if use_association_name

        if association_name_for_parent_resource
          raise "\
            association_name_for_parent_resource specified, but #{parent_resource_method}\
            does not respond_to? #{association_name_for_parent_resource}"
        end

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
        association_name = parent_object
                           ._reflections.map { |r| r[1] } # yay private methods
                           .select { |r| r.klass == resource_class }
                           .first.name

        parent_object.send(association_name)
      end
    end
  end
end
