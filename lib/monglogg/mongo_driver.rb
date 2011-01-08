module Monglogg
  class MongoDriver
    CONFIG_FILE = File.join('config', 'monglogg.yml')
    SEVERITY_TO_SYMBOL = [:debug, :info, :warn, :error, :fatal, :unknown]

    attr_reader :request, :previous_request

    def initialize
      @previous_request = {}
      reload_config!
    end

    def add_message(severity, message)
      @request[:messages][SEVERITY_TO_SYMBOL[severity]] << message
    end

    def add_hash(hash)
      transaction_id = hash.delete(:transaction_id)
      type = hash.delete(:type)
      case type
        when :active_record then      @request[:sql] << hash
        when :render_partial then     @request[:views] << hash
        when :render_collection then  @request[:views] << hash
        when :render_template then    @request[:views] << hash
        when :start_processing then   @request.merge!(hash)
        when :redirect then           @request.merge!(hash)
        when :process_action then     @request.merge!(hash)
        when :custom then             @request[:custom] << hash[:custom]
      end
      finalize_request if type == :process_action
    end

    def reload_config!
      @config = nil
      config
      establish_connection
      prepare_request
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
          :collection => "#{Monglogg::Helper.current_app_name}_#{Rails.env}_log",
          :db => 'monglogg'
        }
        if File.exists? Rails.root.join(CONFIG_FILE)
          config_file = YAML.load(File.read(Rails.root.join(CONFIG_FILE)))
          @config.merge! config_file[Rails.env] if config_file[Rails.env]
          @config[:auth] = true if @config[:username] && @config[:password]
        end
      end

      def finalize_request
        @collection << @request
        @previous_request = @request
        prepare_request
      end

      def prepare_request
        @request = {
          :messages => Hash.new {|h,k| h[k] = Array.new },
          :sql => [],
          :views => [],
          :ip => Monglogg::Helper.current_ip,
          :custom => []
        }
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
