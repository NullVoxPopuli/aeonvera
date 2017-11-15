module ScoutApm
  module Instruments

    class HistogramReport
      attr_reader :name
      attr_reader :histogram

      def initialize(name, histogram)
        @name = name
        @histogram = histogram
      end

      def combine!(other)
        raise "Mismatched Histogram Names" unless name == other.name
        histogram.combine!(other.histogram)
        self
      end
    end

    class PercentileSampler
      attr_reader :logger

      # A hash of { time => RequestHistograms }
      attr_reader :histograms

      def initialize(logger, histograms)
        @logger = logger
        @histograms = histograms
      end

      def human_name
        'Percentiles'
      end

      def metrics(timestamp, store)
        store.track_histograms!(percentiles(timestamp), :timestamp => timestamp)
      end

      def percentiles(time)
        result = []

        histogram = histograms.delete(time)

        return result unless histogram

        histogram.each_name do |name|
          result << HistogramReport.new(name, histogram.raw(name))
        end

        result
      end
    end
  end
end
