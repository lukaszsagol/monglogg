require 'helper'

class TestMonggler < Test::Unit::TestCase
  context "Monggler" do
    setup do
      @logger = Monggler.logger
    end

    should "always return the same logger instance" do
      assert_equal @logger, Monggler.logger
    end
  end
end
