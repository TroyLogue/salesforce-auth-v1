require_relative '../../spec_helper'
require_relative '../../shared_components/base_page.rb'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative 'pages/ar_dashboard_page.rb'
require_relative 'pages/closed_ar_page.rb'

describe '[Close assistance request]', :app_client, :assistance_request do
  include Login
  
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:ar_page) { AssistanceRequest.new(@driver) }
  let(:closed_ar_page) { ClosedAssistanceRequest.new(@driver) }

  before {
    @ar_data = Setup::Data::submit_assistance_request_to_columbia_org

    log_in_as(Login::ORG_COLUMBIA)
    expect(homepage.page_displayed?).to be_truthy
  }

  it 'closes assistance request', :uuqa_1561 do
    ar_page.go_to_new_ar_with_id(ar_id: @ar_data.id)
    expect(ar_page.status_detail_text).to eq("NEEDS ACTION")
    note = Faker::Lorem.sentence(word_count: 5)
    ar_page.close_assistance_request(note)
    ar_page.go_to_closed_ar_with_id(ar_id: @ar_data.id)
    expect(closed_ar_page.status_detail_text).to eq("CLOSED")
  end
end