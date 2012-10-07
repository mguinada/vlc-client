require "vlc/version"

require "vlc/client"
require "vlc/errors"

module VLC
  class << self
    # Initialize VLC
    #
    # @param [Boolean] started if true, object initialization will start
    #                   a VLC instance subprocess. If false VLS starting will be
    #                   client code responsability
    #
    # @return [VLC::VLC] a VLC client
    #
    # @raise [VLC::ConnectionRefused] if the connection fails
    #
    #def init(started = true)
    #  ::VLC::Client.new(started)
    #end
  end
end
