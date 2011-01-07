module Monggler
  class MongoDriver
    CONFIG_FILE = File.join('config', 'monggler.yml')

    def initialize
      reload_config!
    end

    def add_message(severity, message)
    end

    def add_hash(hash)
    end

    def reload_config!
      establish_connection
    end

    def connected?
    end

    private
      def config
      end

      def connection
      end

      def establish_connection
      end
  end
end
