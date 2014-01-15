describe VLC::Client::PlaylistControls do
  after(:each)  { vlc.disconnect }
  let!(:server) { mock_tcp_server }
  let(:vlc)     { VLC::Client.new(:self_managed => false) }

  it 'enqueues media' do
    server.should_receive(:puts).once.with('enqueue media.mp3')
    server.should_receive(:puts).once.with('enqueue media2.mp3')
    vlc.connect

    vlc.add_to_playlist("media.mp3")
    vlc.add_to_playlist("media2.mp3")
  end

  context 'manages the playlist' do
    it 'lists playlist contents' do
      vlc.connect

      vlc.connection.should_receive(:write).once.with("playlist")
      vlc.connection.should_receive(:read).once.with(no_args).and_return("+----[ Playlist - Test ]")
      vlc.connection.should_receive(:read).once.with(no_args).and_return("| 2 - Playlist")
      vlc.connection.should_receive(:read).once.with(no_args).and_return("|   1 - Track 1 (00:01:30) [played 2 times]")
      vlc.connection.should_receive(:read).once.with(no_args).and_return("|   2 - Track 2 (00:00:23)")
      vlc.connection.should_receive(:read).once.with(no_args).and_return("| 3 - Media Library")
      vlc.connection.should_receive(:read).once.with(no_args).and_return("+----[ End of playlist ]")

      vlc.playlist.should eq([{:number => 1, :title => "Track 1", :length => "00:01:30", :times_played => 2},
                              {:number => 2, :title => "Track 2", :length => "00:00:23", :times_played => 0}])
    end

    it 'plays the next element on the playlist' do
      vlc.connect

      vlc.connection.should_receive(:write).once.with("next")
      vlc.next
    end

    it 'plays the previous element on the playlist' do
      vlc.connect

      vlc.connection.should_receive(:write).once.with("prev")
      vlc.previous
    end

    it 'clear the playlist' do
      vlc.connect

      vlc.connection.should_receive(:write).once.with("clear")
      vlc.clear
    end
  end
end