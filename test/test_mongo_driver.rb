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
          config = @mongo.send(:config)

          assert_equal "localhost", config[:host]
          assert_equal 27017,       config[:port]
        end
      end

      should "use correct collection name" do
        assert_equal "#{Monggler::Helper.current_app_name}_#{Rails.env}_log", @mongo.send(:config)[:collection]
      end

      should "create collection if needed" do
        collection_name = @logger.mongo.send(:config)[:collection]
        @mongo.connection.drop_collection(collection_name)
        assert @mongo.collection
      end

      should "load be loaded from file if present" do
        flunk "create this goddamn test"
      end
    end

    context "connection" do
      should "be automatically established" do
        assert @mongo.connected?, "Not connected to MongoDB"
      end

      should "properly disconnect" do
        @mongo.disconnect!
        assert !@mongo.connected?, "Still connected to MongoDB"
      end

      should "be established, when trying to get connection object" do
        @mongo.disconnect!
        @mongo.connection
        assert @mongo.connected?
      end

      should "be established, when trying to get collection object" do
        @mongo.disconnect!
        @mongo.collection
        assert @mongo.connected?
      end
    end
  end
end
