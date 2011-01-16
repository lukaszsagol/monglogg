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
    begin
      yield
    ensure
      FileUtils.mv filename+'.tmp', filename if File.exists? filename+'.tmp'
    end
  end

  def with_file(source_filename, dest_filename, &block)
    FileUtils.install File.join(File.dirname(__FILE__), source_filename), File.join(File.dirname(__FILE__), 'dummy', dest_filename)
    begin
      yield
    ensure
      FileUtils.rm_rf(File.join(File.dirname(__FILE__), 'dummy', dest_filename))
    end
  end

  # cleanup!
  Monglogg.logger.mongo.connection.drop_collection(Monglogg.logger.mongo.config[:collection])
end

