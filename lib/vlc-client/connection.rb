require 'socket'

module VLC
  #
  # Manages the connection to a VLC server
  #
  class Connection
    attr_accessor :host, :port

    def initialize(host, port)
      @host, @port = host, port
      @socket = NullObject.new
    end

    # Connects to VLC RC interface on Client#host and Client#port
    def connect
      @socket = TCPSocket.new(@host, @port)
      2.times { read } #Clean the reading channel
      true
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
    def disconnect
      @socket.close
      @socket = NullObject.new
    end

    alias :close :disconnect

    # Writes data to the TCP server socket
    #
    # @param data the data to write
    # @param fire_and_forget if true, no response response is expected from server,
    #           when false, a response from the server will be returned.
    #
    # @return the server response data if there is one
    #
    def write(data, fire_and_forget = true)
      raise NotConnectedError, "no connection to server" unless connected?
      @socket.puts(data)
      @socket.flush

      return true if fire_and_forget
      read
    rescue Errno::EPIPE
      disconnect
      raise BrokenConnectionError, "the connection to the server is lost"
    end

    # Reads data from the TCP server
    #
    # @return [String] the data
    #
    def read
      #TODO: Timeouts
      raw_data = @socket.gets.chomp
      if (data = process_data(raw_data))
        data[1]
      else
        raise ProtocolError, "could not interpret the playload: #{raw_data}"
      end
    end

    def process_data(data)
      data.match(/^[>*\s*]*(.*)$/)
    end
  end
end