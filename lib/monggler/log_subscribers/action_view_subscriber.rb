module Monggler
  module LogSubscribers
    class ActionViewSubscriber < ActiveSupport::LogSubscriber
      def render_template(event)
        Monggler.logger.add_hash({
          :transaction_id =>    event.transaction_id, 
          :duration =>          event.duration, 
          :view =>              from_rails_root(event.payload[:identifier]),
          :layout =>            from_rails_root(event.payload[:layout]),
          :type =>              :render_template
        })
      end

      def render_partial(event)
        Monggler.logger.add_hash({
          :transaction_id =>    event.transaction_id, 
          :duration =>          event.duration, 
          :view =>              from_rails_root(event.payload[:identifier]),
          :type =>              :render_partial
        })
      end

      def render_collection(event)
        Monggler.logger.add_hash({
          :transaction_id =>    event.transaction_id, 
          :duration =>          event.duration, 
          :view =>              from_rails_root(event.payload[:identifier]),
          :count =>             event.payload[:count],
          :type =>              :render_partial
        })
      end

      private
        def from_rails_root(string)
          string.sub("#{Rails.root}/", "").sub(/^app\/views\//, "")
        end
    end
  end
end
