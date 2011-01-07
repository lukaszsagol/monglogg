require 'rails'

require 'monggler/logger.rb'
require 'monggler/mongo_driver.rb'
require 'monggler/helper.rb'

module Monggler
  class << self
    DEFAULT_LOG_FILE = 'monggler.log'
    
    def logger(log = nil)
      return @@logger if defined?(@@logger)
      unless log
        log = defined?(Rails) ? File.join(Rails.root,'log',Rails.env+'.log') : DEFAULT_LOG_FILE
      end
      @@logger = Logger.new(log)
    end
  end
end
