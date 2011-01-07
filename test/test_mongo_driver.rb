require 'helper'

class TestMongoDriver < Test::Unit::TestCase
  context "Mongo Driver" do
    setup do
      @logger = Monggler.logger
      @mongo = @logger.mongo
    end

    context "configuration" do
      should "use default values, if config file not provided" do
        without_file(Monggler::MongoDriver::CONFIG_FILE) do
          @mongo.reload_config!
          config = @logger.mongo.send(:config)

          assert_equal "localhost", config[:host]
          assert_equal 27017,       config[:port]
        end
      end

      should "use correct collection name" do
        assert_equal "#{Monggler::Helper.current_app_name}_#{Rails.env}_log", @logger.mongo.send(:config)[:collection]
      end
    end

    context "connection" do
      should "be established" do
        assert @mongo.connected?, "Not connected to MongoDB"
      end
    end
  end
end
