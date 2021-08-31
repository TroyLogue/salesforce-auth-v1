# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative 'pages/new_assistance_request_page'
require_relative 'pages/new_assistance_request_dashboard_page'
require_relative 'pages/processed_assistance_request_dashboard_page'
require_relative 'pages/processed_assistance_request_page'
require_relative '../cases/pages/create_case'
require_relative '../cases/pages/open_cases_dashboard'
require_relative '../clients/pages/add_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../root/pages/notifications'

describe '[Serve Assistance Request]', :app_client, :assistance_request do
  let(:homepage) { HomePage.new(@driver) }
  let(:new_assistance_request_page) { NewAssistanceRequestPage.new(@driver) }
  let(:new_assistance_request_dashboard_page) { NewAssistanceRequestDashboardPage.new(@driver) }
  let(:processed_assistance_request_dashboard_page) { ProcessedAssistanceRequestDashboardPage.new(@driver) }
  let(:processed_assistance_request_page) { ProcessedAssistanceRequestPage.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:add_client_page) { AddClient.new(@driver) }
  let(:create_case) { CreateCase.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  before do
    # Submit assistance request
    @assistance_request = Setup::Data.submit_assistance_request_to_columbia_org
    @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_02_USER)

    homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
    expect(homepage.page_displayed?).to be_truthy
  end

  it 'Serve and process AR by creating a case', :uuqa_1639 do
    new_assistance_request_dashboard_page.go_to_new_ar_dashboard_page
    new_assistance_request_dashboard_page.new_ar_dashboard_page_displayed?
    new_assistance_request_dashboard_page.clients_new_ar_created?(@assistance_request.full_name)
    new_assistance_request_page.go_to_new_ar_with_id(ar_id: @assistance_request.ar_id)
    new_assistance_request_page.select_serve_ar_action
    if confirm_client_page.page_displayed?
      confirm_client_page.click_create_new_client
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(fname: fname, lname: lname, dob: dob)).to be_truthy
      add_client_page.save_client
    end
    expect(create_case.create_case_form_displayed?).to be_truthy
    create_case.create_new_case(
      program_id: Setup::Programs.in_network_program_id(
        token: Auth.jwt(email_address: Users::ORG_02_USER),
        group_id: Providers::GENERAL_ORG_02
      ),
      service_type_id: Services::BENEFITS_BENEFITS_ELIGIBILITY_SCREENING,
      primary_worker_id: PrimaryWorkers::ORG_02_USER
    )

    expect(notifications.success_text).to include(Notifications::CASE_CREATED)
    expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

    # combining processed AR with Serve AR since serving AR == processed AR
    processed_assistance_request_dashboard_page.go_to_processed_ar_dashboard_page
    processed_assistance_request_dashboard_page.processed_ar_dashboard_page_displayed?
    processed_assistance_request_dashboard_page.clients_ar_processed?(@assistance_request.full_name)
    processed_assistance_request_page.go_to_processed_ar_with_id(ar_id: @assistance_request.ar_id)
    expect(processed_assistance_request_page.page_displayed?).to be_truthy
    expect(processed_assistance_request_page.outcome_note_text).to eq(@assistance_request.description)
    todays_date = Date.today.strftime('%-m/%-d/%Y')
    expect(processed_assistance_request_page.get_date_closed_text).to include(todays_date, ':')
    expect(processed_assistance_request_page.status_detail_text).to eq(ProcessedAssistanceRequestPage::PROCESSED_STATUS_TEXT)
  end

  after do
    # Closing the API AR submitter as part of cleanup
    Setup::Data.close_columbia_assistance_request(ar_id: @assistance_request.ar_id)
  end
end
