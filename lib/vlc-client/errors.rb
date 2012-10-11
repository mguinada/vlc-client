module VLC
  # Root error class
  class Error < StandardError; end

  # Raised oc connection refusal
  class ConnectionRefused < Error; end
end