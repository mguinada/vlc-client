module VLC
  # Root error class
  class Error < StandardError; end

  # Raised on connection refusal
  class ConnectionRefused < Error; end

  # Raised on communication errors
  class ProtocolError < Error; end

  # Raised on a write to a broken connection
  class BrokenConnectionError < Error; end

  # Raised on a write ti a disconnected connection
  class NotConnectedError < Error; end
end