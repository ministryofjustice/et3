require 'rails_helper'
RSpec.feature "Fill in Confirmation of Supplied Details Page", js: true do
  let(:form_submission_page) { ET3::Test::FormSubmissionPage.new }

  before do
    stub_request(:post, "https://et-api-example.com/v2/repondents/response").
      with(headers: { content_type: 'application/json', 'Accept': 'application/json' }).
      to_return(
        headers: { content_type: 'application/json' },
        body:
          {
            "data": {
              "reference": "992000000100",
              "submitted_at": "2018-01-13 14:00",
              "pdf": "s3/link/to/form/pdf"
            }
          }.to_json,
        status: 201
      )
  end

  scenario "correctly will enable user to continue to next page" do
    given_i_am(:company01)
    answer_all_questions

    confirmation_of_supplied_details_page.submit_form

    expect(form_submission_page).to be_displayed
  end

end
