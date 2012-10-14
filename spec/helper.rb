require 'simplecov'
require 'pry'

#setup simplecov
SimpleCov.start do
  add_filter "/spec"
end

require File.expand_path('../../lib/vlc-client', __FILE__)

module Mocks
  def mock_tcp_server(opts = {})
    tcp = double()
    TCPSocket.stub(:new).and_return do
      if opts.fetch(:defaults, true)
        tcp.should_receive(:gets).with(no_args).twice.and_return("")
        tcp.should_receive(:close).with(no_args)
      end

      yield(tcp) if block_given?
      tcp
    end
    tcp
  end

  def mock_system_calls(opts = {})
    Process.stub(:fork).and_return(1)
    Process.should_receive(:kill).once.with('INT', 1) if opts.fetch(:kill, true)
  end

  def mock_sub_systems
    mock_system_calls
    mock_tcp_server
  end
end

RSpec.configure do |cfg|
  cfg.include(Mocks)
end