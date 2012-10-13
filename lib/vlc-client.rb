require 'uri'
require 'socket'
require 'retryable'

require 'vlc-client/version'

require 'vlc-client/null_object'
require 'vlc-client/server'
require 'vlc-client/connection'
require 'vlc-client/errors'

require 'vlc-client/client/media_controls'

module VLC
  # The VLC client
  class Client
    include VLC::Client::MediaControls

    attr_reader   :host,
                  :port,
                  :server,
                  :auto_start

    # Creates a connection to VLC media player
    #
    # @param [Hash] options
    # @option options [String]  :host The host for the VLC RC interface to connect. Defaults to 'localhost'.
    # @option options [Integer] :port The port for the VLC RC interface to connect. Defaults to 9595.
    # @option options [Boolean] :auto_start 'true' to manage a dedicated instance of VLC. The default. 'false' otherwise.
    # @option options [Integer] :headless 'true' to manage an headless (without GUI) instance of VLC, 'false' otherwaise. Defaults to 'true'.
    #
    # @return [VLC::VLC] a VLC client
    #
    # @raise [VLC::ConnectionRefused] if the connection fails
    #
    def initialize(options = {})
      process_options(options)

      @server = Server.new(host, port, options.fetch(:headless, true))
      @connection = Connection.new(host, port)

      if auto_start
        @server.start
        retryable(:tries => 3, :on => VLC::ConnectionRefused) { connect }
      end
    end

    # Connects to VLC RC interface on Client#host and Client#port
    #
    def connect
      @connection.connect
    end

    # Disconnects from VLC RC interface
    #
    def disconnect
      @connection.disconnect
    end

    # Queries if there is a connection to VLC RC interface
    #
    # @return [Boolean] true is connected, false otherwise
    #
    def connected?
      @connection.connected?
    end

    # Queries if the self managed VLC instance is headless
    #
    def headless
      @server.headless?
    end
    alias :headless? :headless

    def headless=(value)
      @server.headless = value
    end

    private
    def process_options(opts)
      @host       = opts.fetch(:host, 'localhost')
      @port       = opts.fetch(:port, 9595)
      @auto_start = opts.fetch(:auto_start, true)
    end
  end
end
