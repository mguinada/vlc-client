module VLC
  #@ private
  #
  # Manages the connection to a VLC server
  #
  class Connection
    def initialize(host, port)
      @host, @port = host, port
      @socket = NullObject.new
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
      @socket.close
      @socket = NullObject.new
    end

    alias :close :disconnect

    # Writes the the TCP server socket
    #
    # @param data the data to write
    #
    def write(data)
      @socket.puts(data)
    end

    private
    def receive
      #TODO: Timeouts
      @socket.gets.chomp
    end
  end
end