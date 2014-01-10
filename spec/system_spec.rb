describe VLC::System do
  subject { VLC::System.new }

  it 'creates a self-managed VLC media client/server local system' do
    mock_system_calls(:kill => false)
    mock_tcp_server(:close => false)

    subject.client.should be_a(VLC::Client)
    subject.server.should be_a(VLC::Server)
  end

  it 'delegates calls to the client' do
    mock_system_calls(:kill => false)
    mock_tcp_server(:close => false).should_receive(:puts).with('is_playing').once

    should respond_to(:play)
    should_not be_playing
  end

  it 'handles server lifecycle management to client code' do
    mock_tcp_server(:close => false)

    vlc = VLC::System.new('127.0.0.1', 9999, :auto_start => false)

    vlc.server.should_not be_running
    vlc.server.host.should eq('127.0.0.1')
    vlc.server.port.should eq(9999)
  end

  it 'runs server as a daemon process' do
    mock_system_calls(:kill => false, :daemonized => true)
    mock_tcp_server(:close => false)

    vlc = VLC::System.new(:daemonize => true)
    vlc.server.should be_daemonized
  end
end