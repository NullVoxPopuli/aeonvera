module Operations
  #
  # An example Operation may looy like
  #
  # module Operations
  #   class Event::Read < Base
  #     def run
  #       model if allowed?
  #     end
  #   end
  # end
  #
  # TODO: make the above the 'default' and not require to be defined
  class Base
    POLICY_CLASS_PREFIX = 'Policies::'.freeze
    POLICY_CLASS_SUFFIX = 'Policy'.freeze
    POLICY_SUFFIX = '?'.freeze

    attr_accessor :params, :current_user

    class << self
      def run(current_user, params)
        new(current_user, params).run
      end
    end

    def initialize(current_user, params)
      self.current_user = current_user
      self.params = params
    end

    def id_from_params
      id = params[:id]
      if filter = params[:filter]
        id = filter[:id].split(',')
      end

      id
    end

    def scoped_model(scoped_params)
      klass_name = scoped_params[:type]
      operation_name = "Operations::#{klass_name}::Read"
      operation = operation_name.constantize.new(current_user, id: scoped_params[:id])
      operation.run
    end

    def model
      # TODO: not sure if multiple ids is a good idea here
      # if we don't have a(ny) id(s), get all of them
      @model ||=
        if id_from_params
          object_class.find(id_from_params)
        elsif scope = params[:scope]
          if scoped = scoped_model(scope)
            association = association_name_from_object
            scoped.send(association)
          else
            raise "Parent object of type #{scope[:type]} not accessible"
          end
        else
          object_class.where(params).accessible_to(current_user)
        end
    end

    def object_class
      @object_class ||= object_type_of_interest.demodulize.constantize
    end

    def object_type_of_interest
      @object_type_name ||= self.class.name.deconstantize.demodulize
    end

    def association_name_from_object
      object_type_of_interest.tableize
    end

    def policy_class
      @policy_class ||= (
        POLICY_CLASS_PREFIX +
        object_type_of_interest +
        POLICY_CLASS_SUFFIX
      ).constantize
    end

    def policy_name
      @policy_name ||= self.class.name.demodulize.downcase + POLICY_SUFFIX
    end

    def policy_for(object)
      @policy ||= policy_class.new(current_user, object)
    end

    def allowed?
      policy_for(model)
    end

    # checks the policy
    def allowed_for?(object)
      policy_for(object).send(policy_name)
    end
  end
end
