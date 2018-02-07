require 'rollbar'
require 'rollbar/exception_reporter'
require 'rollbar/request_data_extractor'

module Rollbar
  module Middleware
    class Rack
      include ::Rollbar::ExceptionReporter
      include RequestDataExtractor

      def initialize(app)
        @app = app
      end

      def call(env)
        Rollbar.reset_notifier!

        Rollbar.scoped(fetch_scope(env)) do
          begin
            response = @app.call(env)
            report_exception_to_rollbar(env, framework_error(env)) if framework_error(env)
            response
          rescue Exception => e
            report_exception_to_rollbar(env, e)
            raise
          end
        end
      end

      def fetch_scope(env)
        {
          :request => proc { extract_request_data_from_rack(env) },
          :person => person_data_proc(env)
        }
      rescue Exception => e
        report_exception_to_rollbar(env, e)
        raise
      end

      def person_data_proc(env)
        proc { extract_person_data_from_controller(env) }
      end

      def framework_error(env)
        nil
      end
    end
  end
end
