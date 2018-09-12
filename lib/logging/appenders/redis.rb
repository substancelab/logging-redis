# frozen_string_literal: true

require "redis"

module Logging
  module Appenders # :nodoc:
    # Accessor / Factory for the Redis appender.
    def self.redis(*args)
      return ::Logging::Appenders::Redis if args.empty?
      ::Logging::Appenders::Redis.new(*args)
    end

    # Provides an appender that can append log messages to a Redis list
    #
    class Redis < ::Logging::Appender
      include Buffering

      attr_reader :redis

      def initialize(name, opts = {})
        super(name, opts)
        configure_buffering(opts)
        @redis = ::Redis.new
      end

      # Close the Redis appender.
      #
      def close(*_args)
        super(false)
      end

      private

      # This method is called by the buffering code when messages need to be
      # sent out as an Redis.
      #
      def canonical_write(str)
        redis.rpush(name, str)
      rescue StandardError => err
        handle_internal_error(err)
      end

      def handle_internal_error(err)
        return err if off?
        self.level = :off
        ::Logging.log_internal { "appender #{name.inspect} has been disabled" }
        ::Logging.log_internal_error(err)
      end
    end
  end
end
