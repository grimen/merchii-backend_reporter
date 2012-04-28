require 'merchii/background_reporter/version'
require 'active_support/all'

require 'merchii/background_reporter/report'

module Merchii
  module BackgroundReporter

    DEFAULT_OPTIONS = {}

    class ArgumentError < ArgumentError
    end

    class << self

      # == Example:
      #
      #   report("feed:http://example.com:2012-01-01").as("worker-1").push({started_at: Time.now})
      #
      def report(*args)
        raise ::Merchii::BackgroundReporter::ArgumentError, "No arguments." if args.blank?

        key = args.shift

        raise ::Merchii::BackgroundReporter::ArgumentError, "Expects String/Symbol/NilClass, got #{key.class.name}." unless [NilClass, String, Symbol].any? { |klass| key.is_a?(klass) }
        raise ::Merchii::BackgroundReporter::ArgumentError, "Expects key to be non-blank: #{key.inspect}." if key.to_s.blank?

        options = args.shift || {}
        options = DEFAULT_OPTIONS.merge(options)

        Report.new(key, options)
      end

      # def logger
      #   if @@logger.nil?
      #     ::Logger.new('/dev/null')
      #   else
      #     @@logger
      #   end
      # end

      # def logger=(logger)
      #   if logger == false
      #     @@logger = nil
      #   else
      #     @@logger = logger || ::Logger.new(::STDOUT)
      #   end
      # end

    end

  end
end
