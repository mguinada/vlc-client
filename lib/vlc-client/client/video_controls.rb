module VLC
  class Client
    module VideoControls
      # Toggles fullscreen on/off
      def fullscreen
        @connection.write('fullscreen')
      end
    end
  end
end