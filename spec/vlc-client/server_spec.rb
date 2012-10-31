describe VLC::Server do
  let(:server) { VLC::Server.new('localhost', 9595, true) }
  after(:each) { server.stop }

  context 'starts a VLC instance' do
    it 'as a child process' do
      mock_system_calls

      server.start.should_not be_nil
      server.should be_running
    end

    it 'as a deamon' do
      mock_system_calls(:daemonized => true)

      server.daemonize
      server.should be_daemonized
    end
  end

  it 'stops a VLC instance' do
    mock_system_calls

    server.start

    server.stop.should_not be_nil
    server.should_not be_running
  end
end