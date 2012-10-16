describe VLC::Client::VideoControls do
  let(:vlc) { VLC::Client.new(:auto_start => false) }
  after(:each) { vlc.disconnect }

  context 'manipulate the screen size' do
    it 'toggles fullscreen' do
      mock_tcp_server.should_receive(:puts).once.with('fullscreen')

      vlc.connect
      vlc.fullscreen
    end
  end
end