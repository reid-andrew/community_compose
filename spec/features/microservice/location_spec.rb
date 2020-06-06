require 'rails_helper'

RSpec.describe 'Search Location', type: :feature do
  describe 'As a logged in user when I visit the search page' do
    before(:each) do
      @myself = create(:user, username: 'kevin_m', zip: '80222')
      @user1 = create(:user, zip: 80280, username: 'tylerpporter')
      @user2 = create(:user, zip: 80223, username: 'tylerpporter')
      @user3 = create(:user, zip: 90001, username: 'tylerpporter')
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                  .and_return(@myself)
      @json_zips_resp = File.read('spec/fixtures/microservice/location.json')
      stub_request(:get, "https://cc-location-api.herokuapp.com/80222")
                  .to_return(body: @json_zips_resp)

      @funk = File.read('spec/fixtures/flat/user_scores.json')
      stub_request(:get, "https://api.flat.io/v2/users/#{@user1.flat_id}/scores").to_return(status: 200, body: @funk, headers: {})

      @country = File.read('spec/fixtures/flat/alt_user_scores.json')
      stub_request(:get, "https://api.flat.io/v2/users/#{@user2.flat_id}/scores").to_return(status: 200, body: @country, headers: {})

      @jazz = File.read('spec/fixtures/flat/alt_alt_user_scores.json')
      stub_request(:get, "https://api.flat.io/v2/users/#{@user3.flat_id}/scores").to_return(status: 200, body: @jazz, headers: {})
    end

    it 'I get a response' do
      response = Faraday.get('https://cc-location-api.herokuapp.com/80222')
      expect(response.body).to eq(@json_zips_resp)
    end

    it 'I can see other users within my area' do
      visit users_explore_index_path
      user1_score = JSON.parse(@funk, symbolize_names: true)[0][:title]
      user2_score = JSON.parse(@country, symbolize_names: true)[0][:title]
      user3_score = JSON.parse(@jazz, symbolize_names: true)[0][:title]

      within '.scores' do
        expect(page).to have_content(user1_score)
        expect(page).to have_content(user2_score)
        expect(page).to_not have_content(user3_score)
        expect(user2_score).to appear_before(user1_score)
      end
    end

    it 'can see scores from my area' do
      visit users_explore_index_path

      within '.scores' do
        expect(page).to have_css('#score-0')
        expect(page).to have_css('#score-1')
      end
    end
  end
end
