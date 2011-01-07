require 'helper'

class TestLogger < Test::Unit::TestCase
  context "Monggler Logger" do
    context "messages" do
      setup do
        @io = StringIO.new
        @logger = Monggler.logger(@io)
        @message = "This is test message"
        @level = Monggler::Logger::DEBUG
        @logger.add @level, @message
      end

      should "be passed to standard logger" do
        assert @io.string, @message
      end

      should "be stored in mongo" do
        assert @logger.mongo.collection.find(:message => @message, :level => @level).count
      end
    end
  end
end
