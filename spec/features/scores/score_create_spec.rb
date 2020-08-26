require 'rails_helper'

RSpec.describe 'User scores create' do
  before(:each) do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                .and_return(@user)

    json_user_resp = File.read('spec/fixtures/flat/user.json')
    stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200, body: json_user_resp, headers: {})

    json_score_resp = []
    stub_request(:get, "https://api.flat.io/v2/users/me/scores").to_return(status: 200, body: json_score_resp, headers: {})

    visit users_dashboard_index_path
  end

  it 'can create scores from the dashboard' do
    within '.scores' do
      expect(page).to_not have_css('#score-0')
    end

    json_new_score_resp = File.read('spec/fixtures/flat/create_score/create_new_score.json')
    stub_request(:post, "https://api.flat.io/v2/scores").to_return(status: 200, body: json_new_score_resp, headers: {})

    json_score_resp = File.read('spec/fixtures/flat/create_score/users_scores_create_score.json')
    funk = File.read('spec/fixtures/flat/score_show.json')
    stub_request(:get, "https://api.flat.io/v2/users/me/scores").to_return(status: 200, body: json_score_resp, headers: {})
    uri_template = Addressable::Template.new("https://api.flat.io/v2/scores/{id}")
    stub_request(:get, uri_template).to_return(status: 200, body: funk, headers: {})
    fill_in :title, with: 'Funk'
    select 'Treble', from: :clef
    click_on 'Submit Score'


    expect(page).to have_current_path('/scores?score_id=5ed093f4a892cd59c611e0fc')
    expect(page).to have_content('Funk')
  end

  it 'can create different types of score' do
    json_new_score_resp = File.read('spec/fixtures/flat/create_score/create_new_score.json')
    stub_request(:post, "https://api.flat.io/v2/scores").to_return(status: 200, body: json_new_score_resp, headers: {})

    json_score_resp = File.read('spec/fixtures/flat/create_score/users_scores_create_score.json')
    funk = File.read('spec/fixtures/flat/score_show.json')
    stub_request(:get, "https://api.flat.io/v2/users/me/scores").to_return(status: 200, body: json_score_resp, headers: {})
    uri_template = Addressable::Template.new("https://api.flat.io/v2/scores/{id}")
    stub_request(:get, uri_template).to_return(status: 200, body: funk, headers: {})
    fill_in :title, with: 'Bass Funk'
    select 'Bass', from: :clef
    click_on 'Submit Score'

    expect(page).to have_current_path('/scores?score_id=5ed093f4a892cd59c611e0fc')
    expect(page).to have_content('Funk')

    visit users_dashboard_index_path

    fill_in :title, with: 'Combo Funk'
    select 'Both', from: :clef
    click_on 'Submit Score'

    expect(page).to have_current_path('/scores?score_id=5ed093f4a892cd59c611e0fc')
    expect(page).to have_content('Funk')
  end
end
