require 'rails_helper'

RSpec.describe 'Collaborators Features: ', type: :feature do
  describe 'As a user when I view a score ' do
    before(:each) do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                  .and_return(@user)
      json_user_resp = File.read('spec/fixtures/flat/user.json')
      stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200,
                                                                body: json_user_resp,
                                                                headers: {})
      json_score_resp = File.read('spec/fixtures/flat/user_scores.json')
      stub_request(:get, "https://api.flat.io/v2/users/me/scores").to_return(status: 200,
                                                                             body: json_score_resp,
                                                                             headers: {})
      json_score_show_resp = File.read('spec/fixtures/flat/score_show.json')
      expected = nil
      File.open('spec/fixtures/flat/user_scores.json') do |file|
        file.each_line { |line| expected = JSON.parse(line, symbolize_names: true) }
      end
      stub_request(:get, "https://api.flat.io/v2/scores/#{expected[0][:id]}").to_return(status: 200,
                                                                                        body: json_score_show_resp,
                                                                                        headers: {})

      json_collab_resp = File.read('spec/fixtures/flat/add_collaborator.json')
      stub_request(:post, "https://api.flat.io/v2/scores/5ecdacce7b6e796344939fed/collaborators").to_return(status: 200,
                                                                                                            body: json_collab_resp,
                                                                                                            headers: {})
      visit users_dashboard_index_path
      within('.scores') { click_link 'Funk' }
    end

    it 'I can see the collaborators on the score' do
      visit users_dashboard_index_path
      @user.update(username: 'tylerpporter')
      within('.scores') { click_link 'Funk' }

      within('.collaborators') do
        expect(page.all("li").count).to eq(1)
        expect(page).to have_content('tylerpporter')
        click_link 'tylerpporter'
      end

      expect(page).to have_current_path("/users/#{@user.id}")
    end


    it 'I see a button to request to collaborate if it is not my score' do
      within('.collaborators') do
        within ('.requests') do
          expect(page).to have_button('Request to collaborate on this score')
        end
      end
    end

    it 'I do not see a button if I am already a collaborator' do
      @user.update(username: 'tylerpporter')
      visit users_dashboard_index_path
      within('.scores') { click_link 'Funk' }

      within('.collaborators') do
        within ('.requests') do
          expect(page).to_not have_button('Request to collaborate on this score')
        end
      end
    end

    it 'I can request to collaborate & that request shows up for the owner' do
      collab_name = @user[:username]
      within('.collaborators') { click_button('Request to collaborate on this score') }

      expect(current_path).to eq(scores_path)

      visit users_dashboard_index_path
      @user.update(username: 'tylerpporter')
      within('.scores') { click_link 'Funk' }

      within('.collaborators') do
        within ('.requests') do
          expect(page).to have_content(collab_name)
          expect(page.all("li").count).to eq(1)
        end
      end
    end

    it 'I see a flash message confirming my request after I click the button' do
      within('.collaborators') { click_button('Request to collaborate on this score') }

      expect(current_path).to eq(scores_path)
      expect(page).to have_content('Request to collaborate submitted')
    end

    it 'I do not see a button if i have already submitted a request' do
      within('.collaborators') { click_button('Request to collaborate on this score') }
      visit users_dashboard_index_path
      within('.scores') { click_link 'Funk' }

      within('.collaborators') do
        within ('.requests') do
          expect(page).to_not have_button('Request to collaborate on this score')
        end
      end

    end

    it 'I can request to collaborate and be rejected by the owner' do
      collab_name = @user[:username]
      within('.collaborators') { click_button('Request to collaborate on this score') }
      visit users_dashboard_index_path
      @user.update(username: 'tylerpporter')
      within('.scores') { click_link 'Funk'  }

      within('.collaborators') do
        within ('.requests') do
          click_button 'Reject'
        end
      end

      expect(current_path).to eq(scores_path)
      expect(page).to have_content('Request rejected!')
      within('.collaborators') do
        expect(page).to_not have_content(collab_name)
        expect(page).to_not have_content('Requests to Collaborate')
      end
    end

    it 'I can request to collaborate and be approved by the owner' do
      user_two = create(:user)
      user_two.update(username: 'keithjarrett')
      within('.collaborators') { click_button('Request to collaborate on this score') }
      Request.last.update(username: 'keithjarrett')

      visit users_dashboard_index_path
      @user.update(username: 'tylerpporter')
      within('.scores') { click_link 'Funk'  }

      updated_json_score_show_resp = File.read('spec/fixtures/flat/score_show_with_addtl_collab.json')
      expected = nil
      File.open('spec/fixtures/flat/user_scores.json') do |file|
        file.each_line { |line| expected = JSON.parse(line, symbolize_names: true) }
      end
      stub_request(:get, "https://api.flat.io/v2/scores/#{expected[0][:id]}").to_return(status: 200,
                                                                                        body: updated_json_score_show_resp,
                                                                                        headers: {})

      within('.collaborators') do
        within ('.requests') do
          click_button 'Approve'
        end
      end
      expect(current_path).to eq(scores_path)
      expect(page).to have_content('Request approved!')
      within('.collaborators') do
        expect(page).to_not have_content('Requests to Collaborate')
        expect(page).to have_content('keithjarrett')
      end
    end

    it 'I do not have the ability to add collabs if i am not the owner' do
      within('.collaborators') { click_button('Request to collaborate on this score') }
      visit users_dashboard_index_path
      user_two = create(:user)
      user_two.update(username: 'keithjarrett')
      Request.last.update(username: 'keithjarrett')
      @user.update(username: 'tylerpporter')
      within('.scores') { click_link 'Funk'  }
      updated_json_score_show_resp = File.read('spec/fixtures/flat/score_show_with_addtl_collab.json')
      expected = nil
      File.open('spec/fixtures/flat/user_scores.json') do |file|
        file.each_line { |line| expected = JSON.parse(line, symbolize_names: true) }
      end
      stub_request(:get, "https://api.flat.io/v2/scores/#{expected[0][:id]}").to_return(status: 200,
                                                                                        body: updated_json_score_show_resp,
                                                                                        headers: {})
      within('.collaborators') do
        within ('.requests') do
          click_button 'Approve'
        end
      end
      @user.update(username: 'eltonjohn')
      visit users_dashboard_index_path
      within('.scores') { click_link 'Funk' }
      within('.collaborators') { click_button('Request to collaborate on this score') }

      @user.update(username: 'keithjarrett')
      visit users_dashboard_index_path
      within('.scores') { click_link 'Funk' }

      within ('.requests') do
        expect(page).to_not have_button('Request to collaborate on this score')
        expect(page).to_not have_button('Requests to Collaborate')
      end
    end
  end
end
