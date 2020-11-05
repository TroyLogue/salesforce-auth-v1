require_relative '../../shared_components/base_page.rb'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative 'pages/new_assistance_request_page.rb'
require_relative 'pages/new_assistance_request_dashboard_page.rb'
require_relative '../intakes/pages/intake.rb'

describe '[start intake from AR]', :app_client, :assistance_request do
  include Login
  
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:new_assistance_request_page) { NewAssistanceRequestPage.new(@driver) }
  let(:new_assistance_request_dashboard_page) { NewAssistanceRequestDashboardPage.new(@driver) }
  let(:intake_page) { Intake.new(@driver) }

  before {
    # Submit assistance request
    @ar_data = Setup::Data::submit_assistance_request_to_columbia_org

    log_in_as(Login::ORG_COLUMBIA)
    expect(homepage.page_displayed?).to be_truthy
  }

  it 'start intake from AR', :uuqa_1402 do
    new_assistance_request_dashboard_page.go_to_new_ar_dashboard_page
    new_assistance_request_dashboard_page.new_ar_dashboard_page_displayed?
    new_assistance_request_page.go_to_new_ar_with_id(ar_id: @ar_data.id)
    new_assistance_request_page.select_start_intake_action
    intake_page.page_displayed?

    #Validating pre-filled full_name matches with full_name from API AR submit
    expect(intake_page.get_clients_full_name).to eq(@ar_data.requestor.full_name)
  end

  after {
    # Closing the API AR submitter as part of cleanup
    Setup::Data::close_columbia_assistance_request(contact_id: @ar_data.id)
  }
end