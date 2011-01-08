require 'helper'

class TestActiveRecordSubscriber < Test::Unit::TestCase
  context "Active Record Subscriber" do
    should "log when Active Record is accessed" do
      Item.all
      @request = Monglogg.logger.mongo.request
      assert_not_empty @request[:sql].select { |ar| ar[:name] == "Item Load" }
    end
  end
end
