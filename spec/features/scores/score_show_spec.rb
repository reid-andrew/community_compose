require 'rails_helper'

RSpec.describe 'As a User', type: :feature do

  before(:each) do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                .and_return(@user)
    json_user_resp = File.read('spec/fixtures/flat/user.json')
    stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200, body: json_user_resp, headers: {})
    json_score_resp = File.read('spec/fixtures/flat/scores_list.json')
    stub_request(:get, "https://api.flat.io/v2/users/me/scores").to_return(status: 200, body: json_score_resp, headers: {})

    visit users_dashboard_index_path

  end

  it 'I can see a score show page' do
    json_score_resp = File.read('spec/fixtures/flat/score_show.json')

    stub_request(:get, "https://api.flat.io/v2/scores/5ed093f4a892cd59c611e0fc").to_return(status: 200, body: json_score_resp, headers: {})

    within('.scores') do
      click_link 'Funk'
    end

    expect(current_path).to eq(scores_path)
    expect(page).to have_content('Funk')
    expect(page).to have_css('#embed-container')
  end

  it 'I can select a score from the dropdown menu' do
    country = File.read('spec/fixtures/flat/score2_show.json')
    File.read('spec/fixtures/flat/score_show.json')

    stub_request(:get, "https://api.flat.io/v2/scores/5ed2c5181a496566ed1150cc").to_return(status: 200, body: country, headers: {})

    within('.scores') do
      click_link 'Country'
    end

    within('#score-title') do
      expect(page).to have_content('Country')
      expect(page).not_to have_content('Funk')
    end
  end
end
