require_relative '../../shared_components/base_page.rb'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative 'pages/assistance_request_dashboard_page.rb'
require_relative 'pages/closed_assistance_request_page.rb'
require_relative 'pages/new_assistance_request_page.rb'

describe '[Close assistance request]', :app_client, :assistance_request do
  include Login
  
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:assistance_request_dashboard_page) { AssistanceRequestDashboardPage.new(@driver) }
  let(:new_assistance_request_page) { NewAssistanceRequestPage.new(@driver) }
  let(:closed_assistance_request_page) { ClosedAssistanceRequestPage.new(@driver) }
  
  before {
    @ar_data = Setup::Data::submit_assistance_request_to_columbia_org

    log_in_as(Login::ORG_COLUMBIA)
    expect(homepage.page_displayed?).to be_truthy
  }

  it 'closes assistance request', :uuqa_1561 do
    assistance_request_dashboard_page.go_to_new_ar_with_id(ar_id: @ar_data.id)
    expect(assistance_request_dashboard_page.status_detail_text).to eq('NEEDS ACTION')
    note = Faker::Lorem.sentence(word_count: 5)
    assistance_request_dashboard_page.close_assistance_request(note, 'resolved')
    new_assistance_request_page.new_ar_dashboard_displayed?
    assistance_request_dashboard_page.go_to_closed_ar_with_id(ar_id: @ar_data.id)
    expect(closed_assistance_request_page.outcome_note_text).to eq(note)
    expect(closed_assistance_request_page.status_detail_text).to eq('CLOSED')
  end
end