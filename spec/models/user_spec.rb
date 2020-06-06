require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:flat_id) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:about) }
    it { should validate_presence_of(:interests) }
    it { should validate_presence_of(:instruments) }
  end

  describe 'instance_methods' do
    it 'picture' do
      user = create(:user, username: 'tylerpporter', zip: '80005')
      json_user_resp = File.read('spec/fixtures/flat/user.json')
      stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200, body: json_user_resp, headers: {})

      expect(user.picture('890909809809')).to eq("https://lh3.googleusercontent.com/a-/AOh14GgflwGrAlrgssFjPx_xfrIu9Z4-GpvA1B5n60QU")
    end
    it 'distance' do
      user = create(:user, username: 'tylerpporter', zip: '80005')
      json_user_resp = File.read('spec/fixtures/flat/user.json')
      stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200, body: json_user_resp, headers: {})
      zips = {"80004" => 1.4, "80005" => 2.3, "80006" => 4.2}

      expect(user.get_distance(zips)).to eq(2.3)
    end
  end
end
