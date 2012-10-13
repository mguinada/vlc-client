describe VLC::Client::MediaControls do
  let(:vlc) { VLC::Client.new(:auto_start => false) }
  after(:each) { vlc.disconnect }

  context 'palys media' do
    it 'from filesystem' do
      mock_tcp_server.should_receive(:puts).once.with('add ./media.mp3')
      vlc.connect

      vlc.play('./media.mp3')
    end

    it 'from filesystem' do
      File.stub(:open).and_return {
        f = File.new('./LICENSE', 'r')
        f.should_receive(:path).once.and_return('./media.mp3')
        f
      }

      mock_tcp_server.should_receive(:puts).once.with('add ./media.mp3')
      vlc.connect

      vlc.play(File.open("./media.mp3"))
    end

    it 'from web' do
      mock_tcp_server.should_receive(:puts).once.with('add http://example.org/media.mp3')
      vlc.connect

      vlc.play('http://example.org/media.mp3')
    end

    it 'raises error for unknown schemas' do
      mock_tcp_server
      vlc.connect

      expect { vlc.play(Class.new) }.to raise_error(ArgumentError)
    end
  end
end