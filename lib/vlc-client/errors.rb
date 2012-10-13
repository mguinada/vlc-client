module VLC
  # Root error class
  class Error < StandardError; end

  # Raised on connection refusal
  class ConnectionRefused < Error; end
end