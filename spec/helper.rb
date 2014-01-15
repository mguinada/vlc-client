require 'simplecov'
require 'coveralls'

# SimpleCov & Coveralls setup
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter "/spec"
end

require File.expand_path('../../lib/vlc-client', __FILE__)

module Mocks
  def mock_tcp_server(opts = {})
    tcp = double()
    TCPSocket.stub(:new).and_return do
      if opts.fetch(:defaults, true)
        tcp.stub(:flush)
        tcp.should_receive(:gets).with(no_args).at_least(:twice).and_return("")
        tcp.should_receive(:close).with(no_args) if opts.fetch(:close, true)
      end

      yield(tcp) if block_given?
      tcp
    end
    tcp
  end

  def mock_system_calls(opts = {})
    if RUBY_VERSION < "1.9"
      # ruby 1.8.x system call stubs
      rd = double('rd', :read => 99, :close => true)
      wr = double('wr', :close => true)
      IO.stub(:pipe).and_return([rd, wr])
      Process.stub(:fork).twice.and_return(true)
      Process.stub(:pid).once.and_return(99)
      Kernel.stub(:exec)
      [STDIN, STDOUT, STDERR].each { |std| std.stub(:reopen) }
    else
      # ruby 1.9+ process spwan mock
      Process.should_receive(:spawn).once.and_return(99)
    end

    Process.should_receive(:kill).once.with('INT', 99) if opts.fetch(:kill, true)
  end

  def mock_file(filename)
    File.stub(:open).and_return do
      f = File.new('./README.md', 'r')
      f.should_receive(:path).once.and_return(filename)
      f
    end
  end
end

RSpec.configure do |cfg|
  cfg.include(Mocks)
end
