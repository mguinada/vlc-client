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