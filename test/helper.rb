require 'simplecov'
SimpleCov.start do
  add_filter '/test/dummy'
end


require 'test/unit'
require 'shoulda'

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

require 'stringio'
require 'fileutils'

class Test::Unit::TestCase
  def without_file(filename, &block)
    FileUtils.mv filename, filename+'.tmp' if File.exists? filename
    yield
    FileUtils.mv filename+'.tmp', filename if File.exists? filename+'.tmp'
  end

  Monglogg.logger.mongo.connection.drop_collection(Monglogg.logger.mongo.send(:config)[:collection])
end

