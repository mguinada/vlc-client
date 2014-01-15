describe VLC::Client::VideoControls do
  after(:each) { vlc.disconnect }
  let(:vlc)    { VLC::Client.new(:self_managed => false) }

  context 'manipulate the screen size' do
    it 'toggles fullscreen' do
      mock_tcp_server.should_receive(:puts).once.with('fullscreen')

      vlc.connect
      vlc.fullscreen
    end
  end
end