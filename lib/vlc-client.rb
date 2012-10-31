require 'retryable'

require 'vlc-client/null_object'
require 'vlc-client/core_ext/array'

require 'vlc-client/version'

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
    #   @option options [Integer] :conn_retries Number of connection retries (each separated by a second) to make on auto-connect. Defaults to 5.
    #   @option options [Boolean] :daemonize When true and only when on server auto-start mode, the server will be detached and run as a daemon process. Defaults to false.
    #
    #   @example
    #     vlc = VLC::Client.new(VLC::Server.new)
    #     vlc.server.started?
    #     #=> true
    #
    #   @example
    #     vlc = VLC::Client.new(VLC::Server.new, auto_start: false)
    #     vlc.server.started?
    #     #=> false
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
      bind_server(server, options) unless server.nil?
    end

  private
    attr_reader :connection

    def bind_server(server, options = {})
      @connection.host = server.host
      @connection.port = server.port

      if options.fetch(:auto_start, true)
        begin
          options.fetch(:daemonize, false) ? @server.daemonize : @server.start
          retryable(:tries => options.fetch(:conn_retries, 5), :on => VLC::ConnectionRefused) { connect }
        rescue VLC::ConnectionRefused => e
          @server.stop
          raise e
        end
      end
    end

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