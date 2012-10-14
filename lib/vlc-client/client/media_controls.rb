module VLC
  class Client
    module MediaControls
      # Plays media
      #
      # @param media [String, File, URI] the media
      #
      def play(media)
        @connection.write("add #{media_arg(media)}")
      end

      # Stops media currently playing
      #
      def stop
        @connection.write("stop")
      end

      # Queries VLC if media is being played
      #
      def playing?
        @connection.write("is_playing", false) == "1"
      end

      # Queries VLC if playback is currently stopped
      #
      def stopped?
        @connection.write("is_playing", false) == "0"
      end

      private
      def media_arg(media)
        case media
        when File
          media.path
        when String, URI
          media
        else
          raise ArgumentError, "Can play: #{media}"
        end
      end
    end
  end
end