describe VLC::Client do
  context 'initialization' do
    it 'may happen on client construction' do
      vlc = VLC::Client.new
      vlc.should be_running
    end

    it 'may be delegated for developer control' do
      vlc = VLC::Client.new(false)
      vlc.should_not be_running

      vlc.start.should_not be_nil
      vlc.should be_running

      vlc.stop.should_not be_nil
      vlc.should_not be_started
    end
  end
end