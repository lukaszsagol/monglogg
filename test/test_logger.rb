require 'helper'

class TestLogger < Test::Unit::TestCase
  context "Monglogg Logger" do
    context "messages" do
      setup do
        @io = StringIO.new
        @logger = Monglogg.logger(@io)
        @message = "This is test message"
        @level = Monglogg::Logger::DEBUG
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
