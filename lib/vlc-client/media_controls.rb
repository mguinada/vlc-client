module VLC
  class Client
    module MediaControls
      # Plays media
      #
      # @param media [String, File, URI] the media
      #
      def play(media)
        media = case media
                when File
                  media.path
                when String, URI
                  media
                else
                  raise ArgumentError, "Can play: #{media}"
                end

        @connection.write("add #{media}")
      end
    end
  end
end