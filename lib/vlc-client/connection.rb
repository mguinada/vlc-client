require 'socket'
require 'timeout'

module VLC
  #
  # Manages the connection to a VLC server
  #
  class Connection
    DEFAULT_READ_TIMEOUT = 2 #secs

    attr_accessor :host, :port, :read_timeout

    def initialize(host, port, read_timeout=nil)
      @host, @port = host, port
      @socket = NullObject.new
      @read_timeout = read_timeout || DEFAULT_READ_TIMEOUT
    end

    # Connects to VLC RC interface on Client#host and Client#port
    def connect
      @socket = TCPSocket.new(@host, @port)
      #Channel cleanup: some vlc versions echo two lines of text on connect.
      2.times { read(0.1) rescue nil }
      true
    rescue Errno::ECONNREFUSED => e
      raise VLC::ConnectionRefused, "Could not connect to #{@host}:#{@port}: #{e}"
    end

    # Queries if there is a connection to VLC RC interface
    #
    # @return [Boolean] true is connected, false otherwise
    #
    def connected?
      not(@socket.nil?)
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
    # @param timeout read timeout value for a read operation.
    #                If omited the configured value or DEFAULT_READ_TIMEOUT will be used.
    #
    #
    # @return [String] the data
    #
    def read(timeout=nil)
      timeout = read_timeout if timeout.nil?
      raw_data = nil

      Timeout.timeout(timeout) do
        raw_data = @socket.gets.chomp
      end

      if (data = parse_raw_data(raw_data))
        data[1]
      else
        raise VLC::ProtocolError, "could not interpret the playload: #{raw_data}"
      end
    rescue Timeout::Error
      raise VLC::ReadTimeoutError, "read timeout"
    end

    def parse_raw_data(data)
      return nil if data.nil?
      data.match(%r{^[>*\s*]*(.*)$})
    end
  end
end