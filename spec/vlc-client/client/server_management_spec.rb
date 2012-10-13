describe VLC::Client::ServerManagement do
  before(:each) { mock_sub_systems }
  after(:each) { vlc.stop }
  let(:vlc) { VLC::Client.new(:auto_start => true) }

  it 'is aware of embedded server status' do
    vlc.should be_running
  end

  it 'starts a the server' do
    vlc = VLC::Client.new(:auto_start => false)

    vlc.start
    vlc.should be_running
  end

  it 'stops a the server' do
    vlc.stop
    vlc.should_not be_running
  end
end