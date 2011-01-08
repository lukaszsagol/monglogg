require 'rails'
require 'socket'
require 'mongo'

require 'monglogg/logger'
require 'monglogg/mongo_driver'
require 'monglogg/helper'

require 'monglogg/log_subscribers/active_record_subscriber'
require 'monglogg/log_subscribers/action_controller_subscriber'
require 'monglogg/log_subscribers/action_view_subscriber'

module Monglogg
  class << self
    DEFAULT_LOG_FILE = 'monglogg.log'
    
    def logger(log = nil)
      return @@logger if defined?(@@logger)
      unless log
        log = defined?(Rails) ? File.join(Rails.root,'log',Rails.env+'.log') : DEFAULT_LOG_FILE
      end
      @@logger = Logger.new(log)
    end
  end
end

Monglogg::LogSubscribers::ActiveRecordSubscriber.attach_to :active_record
Monglogg::LogSubscribers::ActionControllerSubscriber.attach_to :action_controller
Monglogg::LogSubscribers::ActionViewSubscriber.attach_to :action_view
