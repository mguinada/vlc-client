describe VLC::Client::MediaControls do
  let(:vlc) { VLC::Client.new(:auto_start => false) }

  before(:each) do
    mock_tcp_server do |tcp|
      tcp.should_receive(:puts).once.with('add ./media.mp3')
    end
    vlc.connect
  end

  after(:each) { vlc.disconnect }

  it 'plays media' do
    vlc.play('./media.mp3')
    #vlc.should be_playing?
    #vlc.stop
    #vlc.should_not be_playing
  end
end