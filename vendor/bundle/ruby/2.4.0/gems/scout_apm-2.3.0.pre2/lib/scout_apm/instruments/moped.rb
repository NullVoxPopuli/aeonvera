module ScoutApm
  module Instruments
    class Moped
      attr_reader :logger

      def initalize(logger=ScoutApm::Agent.instance.logger)
        @logger = logger
        @installed = false
      end

      def installed?
        @installed
      end

      def install
        @installed = true

        if defined?(::Moped)
          ScoutApm::Agent.instance.logger.info "Instrumenting Moped"
          ::Moped::Node.class_eval do
            include ScoutApm::Tracer

            def process_with_scout_instruments(operation, &callback)
              if operation.respond_to?(:collection)
                collection = operation.collection
                name = "Process/#{collection}/#{operation.class.to_s.split('::').last}"
                self.class.instrument("MongoDB", name, :annotate_layer => { :query => scout_sanitize_log(operation.log_inspect) }) do
                  process_without_scout_instruments(operation, &callback)
                end
              end
            end
            alias_method :process_without_scout_instruments, :process
            alias_method :process, :process_with_scout_instruments

            # replaces values w/ ?
            def scout_sanitize_log(log)
              return nil if log.length > 1000 # safeguard - don't sanitize large SQL statements
              log.gsub(/(=>")((?:[^"]|"")*)"/) do
                $1 + '?' + '"'
              end
            end
          end
        end
      end

    end
  end
end

