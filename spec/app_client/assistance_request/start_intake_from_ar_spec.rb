require_relative '../root/pages/home_page'
require_relative 'pages/new_assistance_request_page'
require_relative 'pages/new_assistance_request_dashboard_page'
require_relative '../intakes/pages/intake'
require_relative '../clients/pages/confirm_client_page'

describe '[Assistance Requests]', :app_client, :assistance_request do
  let(:homepage) { HomePage.new(@driver) }
  let(:new_assistance_request_page) { NewAssistanceRequestPage.new(@driver) }
  let(:new_assistance_request_dashboard_page) { NewAssistanceRequestDashboardPage.new(@driver) }
  let(:intake_page) { Intake.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }

  before {
    # Submit assistance request
    @assistance_request = Setup::Data.submit_assistance_request_to_columbia_org
    @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_02_USER)

    homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
    expect(homepage.page_displayed?).to be_truthy
  }

  it 'start intake from AR', :uuqa_1402 do
    new_assistance_request_dashboard_page.go_to_new_ar_dashboard_page
    new_assistance_request_dashboard_page.new_ar_dashboard_page_displayed?
    new_assistance_request_dashboard_page.clients_new_ar_created?(@assistance_request.full_name)
    new_assistance_request_page.go_to_new_ar_with_id(ar_id: @assistance_request.ar_id)
    new_assistance_request_page.select_start_intake_action

    confirm_client_page.select_nth_client(index: 0) if confirm_client_page.page_displayed?

    intake_page.page_displayed?

    # Validating pre-filled full_name matches with full_name from API AR submit (case insensitive)
    expect(intake_page.get_clients_full_name.downcase).to eq(@assistance_request.full_name.downcase)
  end

  after {
    # Closing the API AR submitter as part of cleanup
    Setup::Data.close_columbia_assistance_request(ar_id: @assistance_request.ar_id)
  }
end
