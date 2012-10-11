require 'socket'
require 'retryable'

module VLC
  # The VLC client
  class Client
    attr_reader :host,
                :port,
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
      setup_traps

      if auto_start
        start
        retryable(:tries => 3, :on => VLC::ConnectionRefused) { connect }
      end
    end

    # Queries if VLC is running
    #
    # @return [Boolean] true is VLC is running, false otherwise
    #
    def running?
      not @process.nil?
    end

    alias :started? :running?

    # Starts a VLC instance in a subprocess
    #
    # @return [Integer] the subprocess PID or nil if the start command
    #                     as no effect (e.g. VLC already running)
    #
    def start
      return nil if running?
      @process = IO.popen("#{@headless ? 'cvlc' : 'vlc'} --extraintf rc --rc-host #{@host}:#{@port}")
      @process.pid
    end

    # Starts a VLC instance in a subprocess
    #
    # @return [Integer] the terminated subprocess PID or nil if the stop command
    #                     as no effect (e.g. VLC not running)
    #
    def stop
      return nil if not running?
      Process.kill('KILL', pid = @process.pid)
      @process.close
      @process = nil
      disconnect
      pid
    end

    # Connects to VLC RC interface on Client#host and Client#port
    #
    def connect
      @socket = TCPSocket.new(@host, @port)
      2.times { receive } #Clean the reading channel
    rescue Errno::ECONNREFUSED => e
      raise VLC::ConnectionRefused, "Could not connect to #{@host}:#{@port}: #{e}"
    end

    # Disconnects from VLC RC interface
    #
    def disconnect
      @socket.close if connected?
    end

    # Queries if there is a connection to VLC RC interface
    #
    # @return [Boolean] true is connected, false otherwise
    #
    def connected?
      not @socket.nil?
    end

    # Queries if the self managed VLC instance is headless
    #
    def headless?
      @headless = true
    end

    private
    def receive
      @socket.gets.chomp
    end

    def process_options(opts)
      @host       = opts.fetch(:host, 'localhost')
      @port       = opts.fetch(:port, 9595)
      @auto_start = opts.fetch(:auto_start, true)
      @headless   = opts.fetch(:headless, true)
    end

    def setup_traps #not sure about possible side effects
      trap("EXIT") { stop }
      trap("INT")  { stop; exit }
      trap("CLD")  { @process = nil }
    end
  end
end