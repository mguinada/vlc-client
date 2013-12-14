describe VLC::Client::PlaylistControls do
  let(:vlc) { VLC::Client.new(:self_managed => false) }
  after(:each) { vlc.disconnect }

  it 'enqueues media' do
    server = mock_tcp_server
    server.should_receive(:puts).once.with('enqueue media.mp3')
    server.should_receive(:puts).once.with('enqueue media2.mp3')
    vlc.connect

    vlc.add_to_playlist("media.mp3")
    vlc.add_to_playlist("media2.mp3")
  end
end