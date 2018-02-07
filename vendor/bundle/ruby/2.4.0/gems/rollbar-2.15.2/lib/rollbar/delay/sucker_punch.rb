require 'sucker_punch'
require 'sucker_punch/version'

module Rollbar
  module Delay
    class SuckerPunch
      include ::SuckerPunch::Job

      class << self
        attr_accessor :perform_proc
        attr_accessor :ready
      end

      self.ready = false

      def self.setup
        major_version = ::SuckerPunch::VERSION.split.first.to_i

        if major_version > 1
          self.perform_proc = proc { |payload| perform_async(payload) }
        else
          self.perform_proc = proc { |payload| new.async.perform(payload) }
        end

        self.ready = true
      end

      def self.call(payload)
        setup unless ready

        perform_proc.call(payload)
      end

      def perform(*args)
        begin
          Rollbar.process_from_async_handler(*args)
        rescue
          # SuckerPunch can configure an exception handler with:
          #
          # SuckerPunch.exception_handler { # do something here }
          #
          # This is just passed to Celluloid.exception_handler which will
          # push the reiceved block to an array of handlers, by default empty, [].
          #
          # We reraise the exception here casue it's safe and users could have defined
          # their own exception handler for SuckerPunch
          raise
        end
      end
    end
  end
end
