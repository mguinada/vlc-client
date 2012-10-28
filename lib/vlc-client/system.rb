module VLC
  # Local Client/Server VLC system
  class System
    attr_reader :client

    # Creates a local VLC Client/Server system
    #
    # @overload initialize(host, port, options) sets the host and port
    #
    #   @param [String] host The ip to connect to
    #   @param [Integer] port the port
    #   @param [Hash] options
    #   @option options [Boolean] :auto_start When false, the server lifecycle is not managed automatically and controll is passed to the developer
    #
    #   @example
    #     vlc = VLC::System.new('10.10.0.10', 9000)
    #
    # @overload initialize()
    #
    #   @example
    #     vlc = VLC::System.new
    #
    # @return [VLC::Server]
    #
    # @raise [VLC::ConnectionRefused] if the connection fails
    #
    def initialize(*args)
      args = NullObject.Null?(args)
      opts = args.extract_options!

      server = VLC::Server.new
      server.headless = opts.fetch(:headless, false)

      if args.size == 2
        server.host = args.first.to_s
        server.port = Integer(args.last)
      end
      @client = VLC::Client.new(server, opts)
    end

    def server
      client.server
    end

    def respond_to?(method, private_methods = false)
      client.respond_to?(method, private_methods) || super(method, private_methods)
    end

  protected
    # Delegate to VLC::Client
    #
    def method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end
  end
end