require 'helper'

class TestLogger < Test::Unit::TestCase
  context "Monggler Logger" do
    setup do
      @io = StringIO.new
      @logger = Monggler.logger(@io)
    end

    should "pass added messages to standard logger" do
      msg = "This is test message"
      @logger.add 1, msg
      assert @io.string, msg
    end
  end
end
