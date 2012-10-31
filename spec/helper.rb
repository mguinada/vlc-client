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
        tcp.should_receive(:gets).with(no_args).at_least(:twice).and_return("")
        tcp.should_receive(:flush).with(no_args).any_number_of_times
        tcp.should_receive(:close).with(no_args) if opts.fetch(:close, true)
      end

      yield(tcp) if block_given?
      tcp
    end
    tcp
  end

  def mock_system_calls(opts = {})
    if opts.fetch(:daemonized, false)
      Process.should_receive(:fork).once.ordered.and_return(false)

      if RUBY_VERSION < "1.9"
        Process.should_receive(:setsid).once.ordered
        Process.should_receive(:fork).once.ordered.and_return(false)
        Dir.should_receive(:chdir).once.with("/")
      else
        Process.should_receive(:daemon).once
      end
      Process.should_receive(:pid).once.and_return(99)

      rd = stub('rd', :close => true)
      wd = stub('wd', :write => true, :close => true)
      IO.stub(:pipe).and_return([rd, wd])

      [STDIN, STDOUT, STDERR].each { |std| std.stub(:reopen) }

      Kernel.stub(:exec)
    else
      Process.stub(:fork).and_return(true)

      rd = stub('rd', :read => 99, :close => true)
      wd = stub('wd', :close => true)
      IO.stub(:pipe).and_return([rd, wd])

      Process.should_receive(:kill).once.with('INT', 99) if opts.fetch(:kill, true)
    end
  end

  def mock_sub_systems
    mock_system_calls
    mock_tcp_server
  end
end

RSpec.configure do |cfg|
  cfg.include(Mocks)
end