require 'helper'

class TestMonglogg < Test::Unit::TestCase
  context "Monglogg" do
    setup do
      @logger = Monglogg.logger
    end

    should "always return the same logger instance" do
      assert_equal @logger, Monglogg.logger
    end
  end
end
