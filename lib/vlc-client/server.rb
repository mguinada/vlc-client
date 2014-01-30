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
    # @param [Boolean] headless if true VLC media player will run in headless mode.
    #                   i.e. without a graphical interface. Defaults to false
    #
    def initialize(host = 'localhost', port = 9595, headless = false)
      @host, @port, @headless = host, port, headless
      @pid = NullObject.new
      @deamon = false
    end

    # Queries if VLC is running
    #
    # @return [Boolean] true is VLC is running, false otherwise
    #
    def running?
      not(@pid.nil?)
    end

    alias :started? :running?

    # Queries if VLC is stopped
    #
    # @return [Boolean] true is VLC is stopped, false otherwise
    #
    def stopped?
      not(running?)
    end

    # Starts a VLC instance in a subprocess
    #
    # @param [Boolean] detached if true VLC will be started as a deamon process.
    #                     Defaults to false.
    #
    # @return [Integer] the subprocess PID
    #
    # @see #daemonize
    #
    def start(detached = false)
      return @pid if running?
      detached ? @deamon = true : setup_traps

      @pid = if RUBY_VERSION >= '1.9'
               process_spawn(detached)
             else
               process_spawn_ruby_1_8(detached)
             end
    end

    # Start a VLC instance as a system deamon
    #
    #
    # @return [Integer] the subprocess PID or nil if the start command
    #                     as no effect (e.g. VLC already running)
    # @see Server#start
    #
    def daemonize
      start(true)
    end

    # Queries if VLC is running in daemonized mode
    #
    # @see #daemonize
    #
    def daemonized?
      @deamon == true
    end

    # Starts a VLC instance in a subprocess
    #
    # @return [Integer] the terminated subprocess PID or nil if the stop command
    #                     as no effect (e.g. VLC not running)
    #
    def stop
      return nil if stopped?

      Process.kill('INT', pid = @pid)
      @pid = NullObject.new
      @deamon = false
      pid
    end

  private
    def process_spawn(detached)
      if ENV['OS'] == 'Windows_NT'
        # We don't have pgroup, and should write to NUL in case the env doesn't simulate /dev/null
        Process.spawn(headless? ? 'cvlc' : 'vlc',
                             '--extraintf', 'rc', '--rc-host', "#{@host}:#{@port}",
                             :in => 'NUL',
                             :out => 'NUL',
                             :err => 'NUL')
      else
        Process.spawn(headless? ? 'cvlc' : 'vlc',
                      '--extraintf', 'rc', '--rc-host', "#{@host}:#{@port}",
                      :pgroup => detached,
                      :in => '/dev/null',
                      :out => '/dev/null',
                      :err => '/dev/null')
      end
    end

    # For ruby 1.8
    def process_spawn_ruby_1_8(detached)
      rd, wr = IO.pipe
      if Process.fork      #parent
        wr.close
        pid = rd.read.to_i
        rd.close
        return pid
      else                 #child
        rd.close

        detach if detached #daemonization

        wr.write(Process.pid)
        wr.close

        STDIN.reopen "/dev/null"
        STDOUT.reopen "/dev/null", "a"
        STDERR.reopen "/dev/null", "a"

        Kernel.exec "#{headless? ? 'cvlc' : 'vlc'} --extraintf rc --rc-host #{@host}:#{@port}"
      end
    end

    def setup_traps
      trap("EXIT") do
        stop
        exit
      end

      trap("INT") do
        stop
        exit
      end


      trap("CLD") do
        @pid = NullObject.new
        @deamon = false
      end if Signal.list['CLD'] # Windows does not support this signal. Or daemons.
    end

    def detach
     if RUBY_VERSION < "1.9"
        Process.setsid
        exit if Process.fork
        Dir.chdir "/"
      else
        Process.daemon
      end
    end
  end
end
