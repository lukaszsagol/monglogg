module Monglogg
  class Logger < ActiveSupport::BufferedLogger
    def initialize(log, level = DEBUG)
      super
    end

    def mongo
      @mongo ||= MongoDriver.new
    end

    def add(severity, message = nil, progname = nil, &block)
      msg = super
      mongo.add_message(severity, msg)
      msg
    end

    def add_data(hash)
      mongo.add_hash({:type => :custom, :custom => hash})
    end

    def add_hash(hash)
      mongo.add_hash(hash)
    end
  end
end
