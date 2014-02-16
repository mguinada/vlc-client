describe VLC::Client do
  context 'initialization' do
    before(:each) { mock_tcp_server(:close => false) }

    it 'connects to a VLC server' do
      vlc = VLC::Client.new
      vlc.connect
      vlc.should be_connected
    end

    it 'receives host and port' do
      vlc = VLC::Client.new('10.0.0.1', 9999)
      vlc.host.should eq('10.0.0.1')
      vlc.port.should eq(9999)
    end

    it 'is self managed if a server is given' do
      mock_system_calls(:kill => false)

      vlc = VLC::Client.new(VLC::Server.new('10.0.0.1', 9999))
      vlc.server.should be_started
      vlc.should be_connected
    end

    it 'may handle lifecycle management to client code' do
      vlc = VLC::Client.new(VLC::Server.new('10.0.0.1', 9999), :auto_start => false)
      vlc.server.should_not be_started
      vlc.should_not be_connected
    end

    it 'accepts timeout configuration' do
      mock_system_calls(:kill => false)

      vlc = VLC::Client.new(VLC::Server.new('10.0.0.1', 9999), :read_timeout => 3)
      vlc.connection.read_timeout.should eq(3)
    end
  end

  it 'may manage an embedded VLC server' do
    mock_tcp_server(:close => false)
    mock_system_calls(:kill => false)
    VLC::Client.new(VLC::Server.new).server.should be_a(VLC::Server)
  end

  it 'is configurable' do
    vlc = VLC::Client.new(VLC::Server.new, :auto_start => false)
    vlc.server.should_not be_started
  end
end