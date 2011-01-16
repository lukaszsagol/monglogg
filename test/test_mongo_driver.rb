require 'helper'

class TestMongoDriver < Test::Unit::TestCase
  context "Mongo Driver" do
    setup do
      @logger = Monglogg.logger
      @mongo = @logger.mongo
      @mongo.reload_config!
    end

    context "configuration" do
      should "use default values, if config file not provided" do
        without_file(Monglogg::MongoDriver::CONFIG_FILE) do
          @mongo.reload_config!
          config = @mongo.config

          assert_equal "localhost", config[:host]
          assert_equal 27017,       config[:port]
        end
      end

      should "use correct collection name" do
        assert_equal "#{Monglogg::Helper.current_app_name}_#{Rails.env}_log", @mongo.config[:collection]
      end

      should "create collection if needed" do
        collection_name = @mongo.config[:collection]
        @mongo.connection.drop_collection(collection_name)
        assert @mongo.collection
      end

      should "load be loaded from file if present" do
        with_file 'monglogg.yml.template', Monglogg::MongoDriver::CONFIG_FILE do
          @mongo.reload_config!
          assert_equal 'dummy_monglogg_file_test', @mongo.config[:collection]
        end
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
