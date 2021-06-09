# frozen_string_literal: true

require_relative './pages/case'
require_relative './pages/case_dashboard'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'

describe '[Cases]', :app_client, :cases do
  let(:case_detail_page) { Case.new(@driver) }
  let(:closed_case_dashboard) { CaseDashboard::Closed.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a Referral Admin user]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent

      @case = Setup::Data.create_service_case_for_harvard(contact_id: @contact.contact_id)

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'closes a case', :uuqa_1807 do
      case_detail_page.go_to_open_case_with_id(case_id: @case.id, contact_id: @contact.contact_id)
      expect(case_detail_page.page_displayed?).to be_truthy

      # should be required to enter a resolution, outcome, note, and program exit date
      case_detail_page.close_case(
        resolution: ,
        outcome: ,
        note: ,
        program_exit_date:
      )

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CASE_CLOSED)

      # compare values from closing case?

      expect(closed_case_dashboard.page_displayed?).to be_truthy
    end
  end
end
