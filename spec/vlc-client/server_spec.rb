describe VLC::Server do
  let!(:server) do
    mock_system_calls
    server = VLC::Server.new('localhost', 9595, true)
  end
  after(:each) { server.stop }

  it 'starts a VLC instance' do
    server.start.should_not be_nil
    server.should be_running
  end

  it 'stops a VLC instance' do
    server.start

    server.stop.should_not be_nil
    server.should_not be_running
  end
end