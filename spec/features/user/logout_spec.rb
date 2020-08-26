require 'rails_helper'

describe 'As a logged in user' do
  scenario 'I can click a link to logout' do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                .and_return(user)
    json_user_resp = File.read('spec/fixtures/flat/user.json')
    stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200, body: json_user_resp, headers: {})
    json_score_resp = File.read('spec/fixtures/flat/multiple_user_scores.json')
    stub_request(:get, "https://api.flat.io/v2/users/me/scores").to_return(status: 200, body: json_score_resp, headers: {})
    visit users_dashboard_index_path

    click_link "Logged in as #{user.username}"

    expect(current_path).to eq('/')
    expect(page).to have_content("Successfully logged out")
  end
end
