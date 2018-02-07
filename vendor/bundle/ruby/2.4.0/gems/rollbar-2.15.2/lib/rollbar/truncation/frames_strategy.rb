require 'rollbar/truncation/mixin'
require 'rollbar/util'

module Rollbar
  module Truncation
    class FramesStrategy
      include ::Rollbar::Truncation::Mixin

      def self.call(payload)
        new.call(payload)
      end

      def call(payload)
        new_payload = Rollbar::Util.deep_copy(payload)
        body = new_payload['data']['body']

        if body['trace_chain']
          truncate_trace_chain(body)
        elsif body['trace']
          truncate_trace(body)
        end

        dump(new_payload)
      end

      def truncate_trace(body)
        trace_data = body['trace']
        frames = trace_data['frames']
        trace_data['frames'] = select_frames(frames)

        body['trace']['frames'] = select_frames(body['trace']['frames'])
      end

      def truncate_trace_chain(body)
        chain = body['trace_chain']

        body['trace_chain'] = chain.map do |trace_data|
          frames = trace_data['frames']
          trace_data['frames'] = select_frames(frames)
          trace_data
        end
      end
    end
  end
end
