require 'rails_helper'

describe 'As a registered user' do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user)
                                            .and_return(@user1)

    json_user_resp = File.read('spec/fixtures/flat/user.json')
    stub_request(:get, "https://api.flat.io/v2/me").to_return(status: 200,
                                                              body: json_user_resp,
                                                              headers: {})
                                                              
    json_score_resp = File.read('spec/fixtures/flat/user_scores.json')
    stub_request(:get, "https://api.flat.io/v2/users/me/scores").to_return(status: 200,
                                                                            body: json_score_resp,
                                                                            headers: {})
  @user1.send_message(@user2, 'body', 'subject') 
  @conversation = @user1.mailbox.conversations.first
  end

  it 'I can visit my conversations index and see all my conversations listed' do
    visit users_dashboard_index_path
    expect(page).to have_link('Messages')
    click_link 'Messages'
    expect(page).to have_current_path(users_conversations_path)
    within "#conversation-#{@conversation.id}" do
      expect(page).to have_content('subject')
    end
  end

  it 'I can create a new conversation' do
    visit users_dashboard_index_path
    expect(page).to have_link('Messages')
    click_link 'Messages'
    expect(page).to have_current_path(users_conversations_path)

    click_button('Create New Conversation')

    select @user2.username, from: :user_id
    fill_in :subject, with: 'Lets Collab'
    fill_in :body, with: 'Got some great ideas! U in?'
    click_on('Submit')
    new_conversation = @user1.mailbox.conversations.first
    expect(page).to have_current_path("/users/conversations/#{new_conversation.id}")
    expect(page).to have_content("Message sent!")
    expect(page).to have_content('Lets Collab')
  end

  it ' I can visit a conversations show page' do
    visit users_dashboard_index_path
    click_link 'Messages'
    within "#conversation-#{@conversation.id}" do
      click_link('subject')
    end

    expect(page).to have_current_path(users_conversation_path(@conversation))
    expect(page).to have_content('body')
    expect(page).to have_content("#{@user1.username} commented:")
  end

  it 'I can delete a conversation' do
    visit users_dashboard_index_path
    click_link 'Messages'
    within "#conversation-#{@conversation.id}" do
      click_link('Leave Conversation')
    end
    expect(page).to have_current_path(users_conversations_path)
    expect(page).to have_content('Conversation Removed!')
    expect(page).to_not have_content('subject')
  end

  it 'I can reply to the conversation' do
    visit users_dashboard_index_path
    click_link 'Messages'
    within "#conversation-#{@conversation.id}" do
      click_link('subject')
    end
    fill_in :body, with: 'Sounds Great!'
    click_on('Reply')
    time = @conversation.receipts.last.created_at.in_time_zone('America/Denver').strftime('%A, %d %b %Y %l:%M %p')
    expect(page).to have_content('Sounds Great!')
  end

  it 'I can delete a message from the conversation' do
    visit users_dashboard_index_path
    click_link 'Messages'
    within "#conversation-#{@conversation.id}" do
      click_link('subject')
    end

    fill_in :body, with: 'Sounds Great!'
    click_on('Reply')

    message = @conversation.receipts.last
    expect(page).to have_content('Sounds Great!')

    within "#message-#{message.id}" do
      click_link('Delete')
    end
    expect(page).to_not have_content('Sounds Great!')
    expect(page).to have_content('Message Deleted!')
  end
end