module Operations
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

    def model
      @model ||= object_class.find(params[:id])
    end

    def object_class
      @object_class ||= object_type_of_interest.demodulize.constantize
    end

    def object_type_of_interest
      @object_type_name ||= self.class.name.deconstantize.demodulize
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

    # checks the policy
    def allowed_for?(object)
      policy_for(object).send(policy_name)
    end
  end
end
