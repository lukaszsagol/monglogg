require 'helper'

class TestItemsController < ActionController::TestCase
  setup do
    @controller = ItemsController.new
  end

  context "Action View Subscriber" do
    setup do
      get :index
      @request = Monggler.logger.mongo.previous_request
    end
    
    should "properly log rendering template" do
      # TODO: how to check rendering temlpates?
    end

    should "properly log rendering partials" do
      view = @request[:views].select { |v| v[:view] == 'items/_new_item.html.erb' }.first
      assert view
    end

    should "properly log rendering collections" do
      view = @request[:views].select { |v| v[:view] == 'items/_item.html.erb'}.first

      assert view
      assert_equal view[:count], Item.all.count
    end
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
        assert @request[:view_runtime]
        assert @request[:db_runtime]
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

  context "Mongo Driver" do
    setup do
      get :index
    end

    should "save old, and prepare new request hash after request" do
      assert_nil Monggler.logger.mongo.request[:action] 
      assert Monggler.logger.mongo.previous_request[:action] 
    end
  end
end
