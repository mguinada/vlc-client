module VLC
  #@ private
  #
  # Manages the connection to a VLC server
  #
  class Connection
    def initialize(host, port)
      @host, @port = host, port
    end

    # Connects to VLC RC interface on Client#host and Client#port
    #
    def connect
      @socket = TCPSocket.new(@host, @port)
      2.times { receive } #Clean the reading channel
    rescue Errno::ECONNREFUSED => e
      raise VLC::ConnectionRefused, "Could not connect to #{@host}:#{@port}: #{e}"
    end

    # Queries if there is a connection to VLC RC interface
    #
    # @return [Boolean] true is connected, false otherwise
    #
    def connected?
      not @socket.nil?
    end

    # Disconnects from VLC RC interface
    #
    def disconnect
      if connected?
        @socket.close
        @socket = nil
      end
    end

    private
    def receive
      @socket.gets.chomp
    end
  end
end