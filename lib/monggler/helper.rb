module Monggler
  class Helper
    class << self
      def current_app_name
        @app_name ||= Rails.application.class.name.split('::').first.underscore
      end

      def current_ip
        @current_ip ||= UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
      end
    end
  end
end
