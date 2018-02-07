module Dry
  module Configurable
    class Config
      # @private
      class Value
        # @private
        NONE = ::Object.new.freeze

        attr_reader :name, :processor

        def initialize(name, value, processor)
          @name = name.to_sym
          @value = value
          @processor = processor
        end

        def value
          none? ? nil : @value
        end

        def none?
          @value.equal?(::Dry::Configurable::Config::Value::NONE)
        end
      end
    end
  end
end
