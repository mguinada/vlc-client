module VLC
  class Client
    module ConnectionManagement
      # Connects to VLC RC interface on Client#host and Client#port
      def connect
        connection.connect
      end

      # Disconnects from VLC RC interface
      def disconnect
        connection.disconnect
      end

      # Queries if there is an active connection to VLC RC interface
      def connected?
        connection.connected?
      end

      def disconnected?
        not(connected?)
      end
    end
  end
end