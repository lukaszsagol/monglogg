module Monggler
  class MongoDriver
    CONFIG_FILE = File.join('config', 'monggler.yml')
    SEVERITY_TO_SYMBOL = [:debug, :info, :warn, :error, :fatal, :unknown]

    def initialize
      reload_config!
    end

    def add_message(severity, message)
      msg = { 
        :severity => SEVERITY_TO_SYMBOL[severity],
        :message => message,
        :date => Time.now  
      }
      @collection.insert(msg)
    end

    def add_hash(hash)
      # TODO: NYI
    end

    def reload_config!
      @config = nil
      config
      establish_connection
    end
    
    def disconnect!
      @connection.connection.close
    end

    def connected?
      @connection.connection.connected?
    end

    def connection
      return @connection if connected?
      establish_connection
      @connection
    end

    def collection
      return @collection if connected?
      establish_connection
      @collection
    end

    private
      def config
        return @config if defined?(@config) and @config
        @config = {
          :host => 'localhost',
          :port => 27017,
          :collection => "#{Monggler::Helper.current_app_name}_#{Rails.env}_log",
          :db => 'monggler'
        }
        if File.exists? Rails.root.join(CONFIG_FILE)
          config_file = YAML.load(File.read(Rails.root.join(CONFIG_FILE)))
          @config.merge! config_file[Rails.env] if config_file[Rails.env]
          @config[:auth] = true if @config[:username] && @config[:password]
        end
      end

      def establish_connection
        return @connection if @connection and connected?
        @connection = Mongo::Connection.new(config[:host], config[:port], :auto_reconnect => true).db(config[:db])
        @auth = @connection.authenticate(config[:username], config[:password]) if config[:auth]

        unless @connection.collection_names.include? config[:collection]
          @connection.create_collection config[:collection]
        end

        @collection = @connection[config[:collection]]
      end
  end
end
