module VLC
  Error                 = Class.new(StandardError) # Root error class
  ConnectionRefused     = Class.new(Error)         # Raised on connection refusal
  NotConnectedError     = Class.new(Error)         # Raised on a write to a disconnected connection
  BrokenConnectionError = Class.new(Error)         # Raised on a write to a broken connection
  ProtocolError         = Class.new(Error)         # Raised on communication errors
  ReadTimeoutError      = Class.new(Error)         # Raised on a read timeout
end