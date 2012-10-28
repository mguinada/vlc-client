module VLC
  # Manages a local VLC server in a child process
  class Server
    attr_accessor :host, :port, :headless
    alias         :headless? :headless

    #
    # Creates a VLC server lifecycle manager
    #
    # @param [String] host The ip to bind to
    # @param [Integer] port the port
    # @param [Boolean] headless if true VLC media player will run headless.
    #                   i.e. without a graphical interface. Defaults to false
    #
    def initialize(host = 'localhost', port = 9595, headless = false)
      @host, @port, @headless = host, port, headless
      @pid = NullObject.new
      setup_traps
    end

    # Queries if VLC is running
    #
    # @return [Boolean] true is VLC is running, false otherwise
    #
    def running?
      not @pid.nil?
    end

    alias :started? :running?

    # Queries if VLC is stopped
    #
    # @return [Boolean] true is VLC is stopped, false otherwise
    #
    def stopped?; not running?; end

    # Starts a VLC instance in a subprocess
    #
    # @return [Integer] the subprocess PID or nil if the start command
    #                     as no effect (e.g. VLC already running)
    #
    def start
      return NullObject.new if running?
      @pid = Process.fork do
        STDIN.reopen "/dev/null"
        STDOUT.reopen "/dev/null", "a"
        STDERR.reopen "/dev/null", "a"

        exec "#{headless? ? 'cvlc' : 'vlc'} --extraintf rc --rc-host #{@host}:#{@port}"
      end
    end

    # Starts a VLC instance in a subprocess
    #
    # @return [Integer] the terminated subprocess PID or nil if the stop command
    #                     as no effect (e.g. VLC not running)
    #
    def stop
      return NullObject.new if not running?

      Process.kill('INT', pid = @pid)
      @pid = NullObject.new
      pid
    end

    private
    def setup_traps
      trap("EXIT") { stop }
      trap("INT")  { stop }
      trap("CLD")  { stop }
    end
  end
end
