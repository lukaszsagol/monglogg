require 'rails'
require 'socket'
require 'mongo'

require 'monggler/logger'
require 'monggler/mongo_driver'
require 'monggler/helper'

require 'monggler/log_subscribers/active_record_subscriber'
require 'monggler/log_subscribers/action_controller_subscriber'
require 'monggler/log_subscribers/action_view_subscriber'

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

Monggler::LogSubscribers::ActiveRecordSubscriber.attach_to :active_record
Monggler::LogSubscribers::ActionControllerSubscriber.attach_to :action_controller
Monggler::LogSubscribers::ActionViewSubscriber.attach_to :action_view
