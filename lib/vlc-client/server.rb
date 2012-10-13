module VLC
  # Manages a local VLC server in a child process
  #
  class Server
    attr_reader   :host, :port
    attr_accessor :headless
    alias         :headless? :headless

    def initialize(host, port, headless = false)
      @host, @port, @headless = host, port, headless
      setup_traps
    end

    # Queries if VLC is running
    #
    # @return [Boolean] true is VLC is running, false otherwise
    #
    def running?
      not @process.nil?
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
      Process.kill('INT', pid = @process.pid)
      @process = nil
      pid
    end

    private
    def setup_traps #not sure about possible side effects
      trap("EXIT") { stop }
      trap("INT")  { stop; exit }
      trap("CLD")  { @process = nil }
    end
  end
end
