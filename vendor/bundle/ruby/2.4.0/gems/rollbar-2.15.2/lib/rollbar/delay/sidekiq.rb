require 'sidekiq'

module Rollbar
  module Delay
    class Sidekiq
      OPTIONS = { 'queue' => 'rollbar', 'class' => Rollbar::Delay::Sidekiq }.freeze

      def initialize(*args)
        @options = (opts = args.shift) ? OPTIONS.merge(opts) : OPTIONS
      end

      def call(payload)
        ::Sidekiq::Client.push @options.merge('args' => [payload])
      end

      include ::Sidekiq::Worker

      def perform(*args)
        begin
          Rollbar.process_from_async_handler(*args)
        rescue
          # Raise the exception so Sidekiq can track the errored job
          # and retry it
          raise
        end
      end
    end
  end
end
