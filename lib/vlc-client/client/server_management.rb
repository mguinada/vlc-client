module VLC
  class Client
    module ServerManagement
      # Queries if VLC is running
      #
      # @return [Boolean] true is VLC is running, false otherwise
      #
      def running?
        @server.running?
      end

      alias :started? :running?

      # Starts a VLC instance in a subprocess
      #
      # @return [Integer] the subprocess PID or nil if the start command
      #                     as no effect (e.g. VLC already running)
      #
      def start
        @server.start
      end

      # Starts a VLC instance in a subprocess
      #
      # @return [Integer] the terminated subprocess PID or nil if the stop command
      #                     as no effect (e.g. VLC not running)
      #
      def stop
        disconnect
        @server.stop
      end
    end
  end
end