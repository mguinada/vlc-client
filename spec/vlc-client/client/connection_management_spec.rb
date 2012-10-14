describe VLC::Client::ConnectionManagement do
  let(:vlc) { VLC::Client.new(:auto_start => false) }
  before(:each) { mock_tcp_server }
  after(:each) { vlc.disconnect }

  context 'when disconnected' do
    specify { vlc.should be_disconnected }

    it 'connects to VLC' do
      vlc.connect
      vlc.should be_connected
    end
  end

  context 'when connected' do
    before(:each) { vlc.connect }
    specify { vlc.should be_connected }

    it 'disconnects to VLC' do
      vlc.disconnect
      vlc.should be_disconnected
    end
  end
end