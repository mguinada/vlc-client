require 'uri'
require 'socket'
require 'retryable'

require 'vlc-client/version'

require 'vlc-client/null_object'

require 'vlc-client/core_ext/array'

require 'vlc-client/server'
require 'vlc-client/connection'
require 'vlc-client/errors'

require 'vlc-client/client/media_controls'
require 'vlc-client/client/video_controls'
require 'vlc-client/client/connection_management'

require 'vlc-client/system'

module VLC
  # The VLC client
  class Client
    include VLC::Client::MediaControls
    include VLC::Client::VideoControls
    include VLC::Client::ConnectionManagement

    attr_accessor :host,
                  :port,
                  :server

    # Creates a client to manage VLC media player
    #
    # @overload initialize(host, port) sets the host and port
    #
    #   @param [String] host The ip to connect to
    #   @param [Integer] port the port
    #
    #   @example
    #     vlc = VLC::Client.new('10.10.0.10', 9000)
    #
    # @overload initialize(server, options) handle a server wrapper for a self-managed operation mode. This requires a local VLC media play instalation.
    #
    #   @param [Server] server a VLC server lifecycle manager
    #   @param [Hash] options
    #   @option options [Boolean] :auto_start When false, the server lifecycle is not managed automatically and controll is passed to the developer
    #
    #   @example
    #     vlc = VLC::Client.new(VLC::Server.new)
    #     vlc.server.started?
    #     => true
    #
    #     vlc = VLC::Client.new(VLC::Server.new, auto_start: false)
    #     vlc.server.started?
    #     => false
    #
    # @return [VLC::VLC] a VLC client
    #
    # @raise [VLC::ConnectionRefused] if the connection fails
    #
    def initialize(*args)
      args = NullObject.Null?(args)
      options = args.extract_options!

      process_args(args)
      @connection = Connection.new(host, port)

      unless server.nil?
        @connection.host = server.host
        @connection.port = server.port
        begin
          if options.fetch(:auto_start, true)
            @server.start
            retryable(:tries => 5, :on => VLC::ConnectionRefused) { connect }
          end
        rescue VLC::ConnectionRefused => e
          @server.stop
          raise e
        end
      end
    end

    private
    attr_reader :connection

    def process_args(args)
      case args.size
      when 1
        @server = args.first
      when 2
        @host = args.first.to_s
        @port = Integer(args.last)
      else
        @host, @port = 'localhost', 9595
      end
      args
    end
  end
end