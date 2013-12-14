module VLC
  class Client
    module PlaylistControls
      # Adds media to the playlist
      #
      # @param media [String, File, URI] the media to be played
      #
      def add_to_playlist(media)
        connection.write("enqueue #{media_arg(media)}")
      end
    end
  end
end