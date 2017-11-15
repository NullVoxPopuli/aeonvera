# Scope is determined by the first Controller we hit.  Most of the time
# there will only be 1 anyway.  But if you have a controller that calls
# another controller method, we may pick that up:
#     def update
#       show
#       render :update
#     end
module ScoutApm
  module LayerConverters
    class FindLayerByType
      def initialize(request)
        @request = request
      end

      def scope
        @scope ||= call(["Controller", "Job"])
      end

      def job
        @job ||= call(["Job"])
      end

      def queue
        @queue ||= call(["Queue"])
      end

      def call(layer_types)
        walker = DepthFirstWalker.new(@request.root_layer)
        walker.on {|l| return l if layer_types.include?(l.type) }
        walker.walk
      end
    end
  end
end
