require 'uri'

module VLC
  class Client
    module MediaControls
      # Plays media or resumes playback
      #
      # @overload play(media)
      #   addes the given media and plays it
      #
      #   @param media [String, File, URI] the media to be played
      #
      #   @example
      #     vlc.play('http://example.org/media.mp3')
      #
      # @overload play
      #   plays the current media or resume playback is paused
      #
      #   @example
      #     vlc.play('http://example.org/media.mp3')
      #     vlc.pause
      #     vlc.play #resume playback
      #
      def play(media = nil)
        connection.write(media.nil? ? "play" : "add #{media_arg(media)}")
      end

      # Pauses playback
      def pause
        connection.write("pause")
      end

      # Stops media currently playing
      def stop
        connection.write("stop")
      end

      # Gets the title of the media at play
      def title
        connection.write("get_title", false)
      end

      # Gets the current playback progress in time
      #
      # @return [Integer] time in seconds
      #
      def time
        Integer(connection.write("get_time", false))
      rescue ArgumentError
        0
      end

      # Gets the length of the media being played
      #
      # @return [Integer] time in seconds
      #
      def length
        Integer(connection.write("get_length", false))
      rescue ArgumentError
        0
      end

      # Get the progress of the the media being played
      #
      # @return [Integer] a relative value on percentage
      #
      def progress
        l = length
        l.zero? ? 0 : 100 * time / l
      end

      # Queries VLC if media is being played
      def playing?
        connection.write("is_playing", false) == "1"
      end

      # Queries VLC if playback is currently stopped
      def stopped?
        connection.write("is_playing", false) == "0"
      end

      # Queries/Sets VLC volume level
      #
      # @overload volume()
      #
      #   @return [Integer] the current volume level
      #
      # @overload volume(level)
      #
      #   @param [Integer] level the volume level to set
      #
      def volume(level = nil)
        level.nil? ? Integer(connection.write("volume", false)) : connection.write("volume #{Integer(level)}")
      rescue ArgumentError
        level.nil? ? 0 : nil
      end

      # @see #volume
      def volume=(level)
        volume(level)
      end
    end
  end
end
