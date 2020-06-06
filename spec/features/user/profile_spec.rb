require 'rails_helper'

describe 'As a registered user' do
  describe 'when I visit users/:id' do
    scenario 'I should see that users profile' do
      user = create(:user, username: 'tylerpporter')
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                        .and_return(user)
      json_user_resp = File.read('spec/fixtures/flat/user.json')
      stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200, body: json_user_resp, headers: {})
      

      visit user_path(user.id)

      expect(page).to have_content(user.username)
      expect(page).to have_content(user.about)
      expect(page).to have_content("Genres Of Interest: #{user.interests}")
      expect(page).to have_content("Instruments I Play: #{user.instruments}")
    end
  end
  describe 'when I visit my dashboard' do
    scenario 'I can click a link to view my profile' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                  .and_return(user)
      json_user_resp = File.read('spec/fixtures/flat/user.json')
      stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200, body: json_user_resp, headers: {})
      json_score_resp = File.read('spec/fixtures/flat/user_scores.json')
      stub_request(:get, "https://api.flat.io/v2/users/me/scores").to_return(status: 200, body: json_score_resp, headers: {})
      visit users_dashboard_index_path
      click_link 'My Profile'

      expect(current_path).to eq(user_path(user.id))
      expect(page).to have_content(user.username)
    end
  end
end
