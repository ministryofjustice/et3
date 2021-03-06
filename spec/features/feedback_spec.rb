require 'rails_helper'

RSpec.feature 'Feedback form', js: true do

  before do
    stub_request(:post, "#{ENV.fetch('ET_API_URL', 'http://api.et.127.0.0.1.nip.io:3100/api')}/v2/feedback/build_feedback")
  end

  scenario 'filling in the feedback form' do
    given_valid_user
    feedback_page.load(locale: current_locale_parameter)
    feedback_factory = FactoryBot.create(:feedback)
    expect(feedback_page).to be_displayed
    feedback_page.fill_in_feedback(feedback_factory)
    sleep 4 # Else we will be seen as a bot for entering too quickly
    feedback_page.submit

    expect(feedback_page).to have_thank_you_message

    expect(a_request(:post, "http://api.et.127.0.0.1.nip.io:3100/api/v2/feedback/build_feedback").
        with(body: hash_including(
            'command' => 'BuildFeedback',
            'data' => a_hash_including(
                'problems' => feedback_factory.problems,
                'suggestions' => feedback_factory.suggestions,
                'email_address' => feedback_factory.email_address
            )))).to have_been_made
  end
end
