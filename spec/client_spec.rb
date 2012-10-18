describe VLC::Client do
  context 'initialization' do
    before(:each) { mock_sub_systems }

    it 'starts a dedicated VLC instance by default' do
      vlc = VLC::Client.new(:self_managed => true)
      vlc.server.should be_running
      vlc.should be_connected #auto-connect

      vlc.disconnect
      vlc.server.stop
    end

    it 'can disregard VLC dedicated instance' do
      vlc = VLC::Client.new(:self_managed => false)
      vlc.server.should_not be_running

      vlc.server.start.should_not be_nil
      vlc.server.should be_running

      vlc.server.stop.should_not be_nil
      vlc.server.should be_stopped
      vlc.should_not be_connected
    end
  end

  it 'contains an embedded VLC server' do
    mock_system_calls(:kill => false)
    VLC::Client.new(:self_managed => false).server.should be_a(VLC::Server)
  end

  it 'is configurable' do
    vlc = VLC::Client.new(:self_managed => false,
                          :host => '192.168.1.10',
                          :port => 9999,
                          :headless => true)

    vlc.server.should_not be_running
    vlc.host.should eq('192.168.1.10')
    vlc.port.should eq(9999)
    vlc.should be_headless

    #headless is the only interactive config property
    vlc.headless = false
    vlc.should_not be_headless
  end
end