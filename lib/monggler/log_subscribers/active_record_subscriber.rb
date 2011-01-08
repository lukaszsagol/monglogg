module Monggler
  module LogSubscribers
    class ActiveRecordSubscriber < ActiveSupport::LogSubscriber
      def sql(event)
        Monggler.logger.add_hash({
          :transaction_id =>  event.transaction_id,
          :duration =>        event.duration,
          :sql =>             event.payload[:sql],
          :name =>            event.payload[:name],
          :type =>            :active_record
        })
      end
    end
  end
end
