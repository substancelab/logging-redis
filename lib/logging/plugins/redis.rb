# frozen_string_literal: true

module Logging
  module Plugins
    module Redis
      module_function

      VERSION = '0.0.1'.freeze

      # This method will be called by the Logging framework when it first
      # initializes. Here we require the redis appender code.
      def initialize_redis
        require File.expand_path('../appenders/redis', __dir__)
      end
    end
  end
end
