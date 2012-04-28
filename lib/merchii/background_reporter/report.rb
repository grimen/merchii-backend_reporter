require 'merchii/background_reporter/adapters/s3'

module Merchii
  module BackgroundReporter
    class Report

      DEFAULT_OPTIONS = {}

      class ArgumentError < ArgumentError
      end

      def initialize(*args)
        raise ::Merchii::BackgroundReporter::Report::ArgumentError, "No arguments." if args.blank?
        key = args.shift
        raise ::Merchii::BackgroundReporter::Report::ArgumentError, "Expects String/Symbol/NilClass, got #{key.class.name}." unless [NilClass, String, Symbol].any? { |klass| key.is_a?(klass) }

        options = args.shift || {}
        options = DEFAULT_OPTIONS.merge(options)
        options.merge!({:key => key})

        @reporter = nil
        @adapter = Adapters::S3.new(options)
      end

      def adapter
        @adapter
      end

      def reporter(*args)
        return @reporter if args.blank?

        reporter = args.shift
        reporter = reporter.to_sym if reporter.is_a?(String)

        raise ::Merchii::BackgroundReporter::Report::ArgumentError, "Expects String/Symbol/NilClass, got #{reporter.class.name}." unless [NilClass, String, Symbol].any? { |klass| reporter.is_a?(klass) }
        raise ::Merchii::BackgroundReporter::Report::ArgumentError, "Expects key to be non-blank: #{reporter.inspect}." if reporter.to_s.blank?

        @reporter = reporter
        self
      end
      alias :as :reporter

      # Check what the report holds for current reporter defined by +#as+ (+@reporter+).
      def get
        @adapter[@reporter]
      end

      # Add a object to the report for the reporter defined by +#as(id)+ (+@reporter+).
      # Expects: +Hash+
      def push(*args)
        raise ::Merchii::BackgroundReporter::Report::ArgumentError, "No arguments." if args.blank?
        data = args.shift
        raise ::Merchii::BackgroundReporter::Report::ArgumentError, "Expects Hash, got #{data.class.name}." unless data.is_a?(::Hash)

        @adapter[@reporter] = (@adapter[@reporter] || {}).merge(data)
      end

      # Clear object for current reporter defined by +#as+ (+@reporter+).
      def clear
        @adapter[@reporter] = {}
      end

    end
  end
end
