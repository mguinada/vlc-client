module VLC
  class Client
    module PlaylistControls
      # @private
      PLAYLIST_TERMINATOR = "+----[ End of playlist ]"

      # @private
      LIST_ITEM_REGEXP = %r{
        ^\|[\s]*
        (?<number>\d{1,2})\s-\s(?<title>.+)
        \((?<length>\d\d:\d\d:\d\d)\)(\s\[played\s
        (?<times_played>\d+)\stime[s]?\])?
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

          {:number       => match[:number].to_i,
           :title        => match[:title].strip,
           :length       => match[:length],
           :times_played => match[:times_played].to_i}
        end.compact
      end
    end
  end
end
