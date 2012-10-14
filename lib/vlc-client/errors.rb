module VLC
  # Root error class
  class Error < StandardError; end

  # Raised on connection refusal
  class ConnectionRefused < Error; end

  # Raised on communication errors
  class ProtocolError < Error; end
end