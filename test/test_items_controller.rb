require 'helper'

class TestItemsController < ActionController::TestCase
  setup do
    @controller = ItemsController.new
  end

  context "Action Controller Subscriber" do
    context "after normal request" do
      setup do 
        get :index
        @request = Monggler.logger.mongo.previous_request
      end

      should "properly log start of processing requests" do
        params = {"action" => "index", "controller" => "items"}

        assert_equal "ItemsController", @request[:controller]
        assert_equal "index",           @request[:action]
        assert_equal "GET",             @request[:method]
        assert_equal [:html],           @request[:formats]
        assert_equal items_path,        @request[:path]
        assert_equal params,            @request[:params]
      end

      should "properly log action process" do
        assert_equal 200,               @request[:status]
      end
    end

    context "redirect request" do
      setup do
        get :redirect
        @request = Monggler.logger.mongo.previous_request
      end

      should "properly log redirect" do
        assert_equal items_url,         @request[:redirect]
        assert_equal 302,               @request[:status]
      end
    end
  end
end
