module Monggler
  class Logger < ActiveSupport::BufferedLogger
    def initialize(log, level = DEBUG)
      super
    end

    def mongo
      @mongo ||= MongoDriver.new
    end

    def add(severity, message = nil, progname = nil, &block)
      msg = super
      # TODO: send message to mongo
    end

    def add_hash(hash)
      # TODO: send hash to mongo
    end
  end
end
