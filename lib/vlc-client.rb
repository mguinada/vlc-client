require 'uri'
require 'socket'
require 'retryable'

require 'vlc-client/version'

require 'vlc-client/null_object'
require 'vlc-client/server'
require 'vlc-client/connection'
require 'vlc-client/errors'

require 'vlc-client/client/media_controls'
require 'vlc-client/client/video_controls'
require 'vlc-client/client/connection_management'

module VLC
  # The VLC client
  class Client
    include VLC::Client::MediaControls
    include VLC::Client::VideoControls
    include VLC::Client::ConnectionManagement

    attr_reader   :host,
                  :port,
                  :server,
                  :self_managed

    # Creates a connection to VLC media player
    #
    # @param [Hash] options
    # @option options [String]  :host The host for the VLC RC interface to connect. Defaults to 'localhost'.
    # @option options [Integer] :port The port for the VLC RC interface to connect. Defaults to 9595.
    # @option options [Boolean] :self_managed 'true' to manage a dedicated instance of VLC. The default. 'false' otherwise.
    # @option options [Integer] :headless 'true' to manage an headless (without GUI) instance of VLC, 'false' otherwaise. Defaults to 'true'.
    #
    # @return [VLC::VLC] a VLC client
    #
    # @raise [VLC::ConnectionRefused] if the connection fails
    #
    def initialize(options = {})
      process_options(options)

      @server = Server.new(host, port, options.fetch(:headless, false))
      @connection = Connection.new(host, port)

      if self_managed
        begin
          @server.start
          retryable(:tries => 5, :on => VLC::ConnectionRefused) { connect }
        rescue VLC::ConnectionRefused => e
          @server.stop
          raise e
        end
      end
    end

    # Queries if the self managed VLC instance is headless
    def headless
      @server.headless?
    end
    alias :headless? :headless

    def headless=(value)
      @server.headless = value
    end

    private
    attr_reader :connection

    def process_options(opts)
      @host         = opts.fetch(:host, 'localhost')
      @port         = opts.fetch(:port, 9595)
      @self_managed = opts.fetch(:self_managed, true)
    end
  end
end