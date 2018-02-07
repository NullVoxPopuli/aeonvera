module Rollbar
  module Truncation
    module Mixin
      def dump(payload)
        Rollbar::JSON.dump(payload)
      end

      def truncate?(result)
        result.bytesize > MAX_PAYLOAD_SIZE
      end

      def select_frames(frames, range = 150)
        return frames unless frames.count > range * 2

        frames[0, range] + frames[-range, range]
      end
    end
  end
end
