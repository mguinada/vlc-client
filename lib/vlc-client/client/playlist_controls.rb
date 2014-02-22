module VLC
  class Client
    module PlaylistControls
      # @private
      PLAYLIST_TERMINATOR = "+----[ End of playlist ]"

      # @private
      LIST_ITEM_REGEXP = %r{
        ^\|[\s]*(\d{1,2})\s-\s(.+)
        \((\d\d:\d\d:\d\d)\)
        (\s\[played\s(\d+)
        \stime[s]?\])?
      }x

      # Adds media to the playlist
      #
      # @param media [String, File, URI] the media to be played
      #
      def add_to_playlist(media)
        connection.write("enqueue #{media_arg(media)}")
      end

      # Lists tracks on the playlist
      def playlist
        connection.write("playlist")

        list = []
        begin
          list << connection.read
        end while list.last != PLAYLIST_TERMINATOR

        parse_playlist(list)
      end

      # Plays the next element on the playlist
      def next
        connection.write("next")
      end

      # Plays the previous element on the playlist
      def previous
        connection.write("prev")
      end

      # Clears the playlist
      def clear
        connection.write("clear")
      end

    private
      def parse_playlist(list)
        list.map do |item|
          match = item.match(LIST_ITEM_REGEXP)

          next if match.nil?

          {:number       => match[1].to_i,
           :title        => match[2].strip,
           :length       => match[3],
           :times_played => match[5].to_i}
        end.compact
      end
    end
  end
end
