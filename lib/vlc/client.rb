require 'socket'

module VLC
  # The VLC client
  class Client
    # Creates a connection to VLC media player
    #
    # @param [Boolean] started if true, object initialization will start
    #                   a VLC instance subprocess. If false VLS starting will be
    #                   client code responsability
    #
    # @return [VLC::VLC] a VLC client
    #
    # @raise [VLC::ConnectionRefused] if the connection fails
    #
    def initialize(started = true)
      start if started
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
      @process = IO.popen('cvlc')
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
      pid
    end
  end
end