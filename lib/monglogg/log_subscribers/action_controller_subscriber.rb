module Monglogg
  module LogSubscribers
    class ActionControllerSubscriber < ActiveSupport::LogSubscriber
      def start_processing(event)
        Monglogg.logger.add_hash({
          :transaction_id =>  event.transaction_id,
          :controller =>      event.payload[:controller],
          :action =>          event.payload[:action],
          :method =>          event.payload[:method],
          :formats =>         event.payload[:formats],
          :path =>            event.payload[:path],
          :params =>          event.payload[:params],
          :time =>            event.time,
          :type =>            :start_processing
        })
      end

      def process_action(event)
        Monglogg.logger.add_hash({
          :transaction_id =>  event.transaction_id,
          :status =>          event.payload[:status],
          :view_runtime =>    event.payload[:view_runtime],
          :db_runtime =>      event.payload[:db_runtime],
          :type =>            :process_action
        })
      end
      
      def send_file(event)
        # TODO: NYI
      end

      def redirect_to(event)
        Monglogg.logger.add_hash({
          :transaction_id =>  event.transaction_id,
          :redirect =>        event.payload[:location],
          :type =>            :redirect
        })
      end

      def send_data(event)
        # TODO: NYI
      end

      def write_fragment(event)
        # TODO: NYI
      end

      def read_fragment(event)
        # TODO: NYI
      end

      def exist_fragment?(event)
        # TODO: NYI
      end

      def expire_fragment(event)
        # TODO: NYI
      end

      def expire_page(event)
        # TODO: NYI
      end
      
      def write_page(event)
        # TODO: NYI
      end
    end
  end
end
