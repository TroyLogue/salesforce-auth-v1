require_relative '../root/pages/home_page'
require_relative 'pages/new_assistance_request_dashboard_page'
require_relative 'pages/closed_assistance_request_dashboard_page'
require_relative 'pages/closed_assistance_request_page'
require_relative 'pages/new_assistance_request_page'
require_relative '../root/pages/notifications'

describe '[Assistance request]', :app_client, :assistance_request do
  let(:homepage) { HomePage.new(@driver) }
  let(:new_assistance_request_page) { NewAssistanceRequestPage.new(@driver) }
  let(:new_assistance_request_dashboard_page) { NewAssistanceRequestDashboardPage.new(@driver) }
  let(:closed_assistance_request_page) { ClosedAssistanceRequestPage.new(@driver) }
  let(:closed_assistance_request_dashboard_page) { ClosedAssistanceRequestDashboardPage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  before {
    # Submit assistance request before each test
    @assistance_request = Setup::Data.submit_assistance_request_to_columbia_org
    @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_02_USER)
  }

  context '[As ORG user]' do
    before {
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'Close assistance request', :uuqa_1561 do
      new_assistance_request_dashboard_page.go_to_new_ar_dashboard_page
      new_assistance_request_dashboard_page.new_ar_dashboard_page_displayed?
      new_assistance_request_dashboard_page.clients_new_ar_created?(@assistance_request.full_name)

      # Visit client's AR page and close AR
      new_assistance_request_page.go_to_new_ar_with_id(ar_id: @assistance_request.ar_id)
      expect(new_assistance_request_page.status_detail_text).to eq(NewAssistanceRequestPage::NEED_ACTION_STATUS_TEXT)
      note = Faker::Lorem.sentence(word_count: 5)
      new_assistance_request_page.close_assistance_request(note, 'resolved')
      new_assistance_request_dashboard_page.new_ar_dashboard_page_displayed?
      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::ASSISTANCE_REQUEST_CLOSED)

      # Visit client's closed AR page to validate AR was closed
      closed_assistance_request_page.go_to_closed_ar_with_id(ar_id: @assistance_request.ar_id)
      expect(closed_assistance_request_page.outcome_note_text).to eq(note)
      expect(closed_assistance_request_page.status_detail_text).to eq(ClosedAssistanceRequestPage::CLOSED_STATUS_TEXT)
    end
  end

  context '[As ORG user]' do
    before {
      # Close the assistance request that is created via API before the test run
      @closed_ar = Setup::Data::close_columbia_assistance_request(ar_id: @assistance_request.ar_id)

      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'Validate assistance request is closed today', :uuqa_1671 do
      closed_assistance_request_dashboard_page.go_to_closed_ar_dashboard_page
      closed_assistance_request_dashboard_page.closed_ar_dashboard_page_displayed?
      closed_assistance_request_dashboard_page.clients_ar_closed?(@assistance_request.full_name)

      # Validates time on date closed column on the dashboard == time AR was closed via api
      expect(closed_assistance_request_dashboard_page.date_closed_column_text(@closed_ar.full_name)).to eq(@closed_ar.time_ar_closed)

      # Visit client's closed AR page to validate AR was closed
      closed_assistance_request_page.go_to_closed_ar_with_id(ar_id: @assistance_request.ar_id)
      expect(closed_assistance_request_page.outcome_note_text).to eq(@closed_ar.note)
      expect(closed_assistance_request_page.get_date_closed_text).to eq("#{@closed_ar.date_ar_closed} at #{@closed_ar.time_ar_closed}")
      expect(closed_assistance_request_page.status_detail_text).to eq(ClosedAssistanceRequestPage::CLOSED_STATUS_TEXT)
    end
  end
end
