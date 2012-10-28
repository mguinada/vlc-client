describe VLC::System do
  before(:each) do
    mock_tcp_server(:close => false)
    mock_system_calls(:kill => false)
  end

  subject { VLC::System.new }

  it 'creates a self-managed VLC media client/server local system' do
    subject.client.should be_a(VLC::Client)
    subject.server.should be_a(VLC::Server)
  end

  it 'delegates calls to the client' do
    should respond_to(:play)
  end

  it 'handles server lifecycle management to client code' do
    vlc = VLC::System.new('127.0.0.1', 9999, :auto_start => false)

    vlc.server.should_not be_running
    vlc.server.host.should eq('127.0.0.1')
    vlc.server.port.should eq(9999)
  end
end