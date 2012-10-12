describe VLC::Client do
  context 'initialization' do
    before(:each) { mock_sub_systems }

    it 'starts a dedicated VLC instance by default' do
      vlc = VLC::Client.new
      vlc.should be_running
      vlc.should be_connected
      vlc.stop
    end

    it 'can disregard VLC dedicated instance' do
      vlc = VLC::Client.new(:auto_start => false)
      vlc.should_not be_running

      vlc.start.should_not be_nil
      vlc.should be_running

      vlc.stop.should_not be_nil
      vlc.should_not be_started
      vlc.should_not be_connected
    end
  end

  it 'is configurable' do
    vlc = VLC::Client.new(:auto_start => false,
                          :host => '192.168.1.10',
                          :port => 9999,
                          :headless => true)

    vlc.should_not be_running
    vlc.host.should eq('192.168.1.10')
    vlc.port.should eq(9999)
    vlc.should be_headless
  end
end