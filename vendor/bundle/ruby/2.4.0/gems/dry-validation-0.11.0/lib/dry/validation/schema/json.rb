require 'dry/validation/schema'

module Dry
  module Validation
    class Schema::JSON < Schema
      def self.configure(klass = nil, &block)
        if klass
          klass.configure do |config|
            config.input_processor = :json
            config.hash_type = :symbolized
          end
          klass
        else
          super(&block)
        end
      end

      configure(self)
    end
  end
end
