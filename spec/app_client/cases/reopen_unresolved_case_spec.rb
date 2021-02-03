# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../cases/pages/case'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'

describe '[Cases]', :app_client, :cases do
  include Login

  let(:case_detail_page) { Case.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a Referrals Admin user]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent

      @case = Setup::Data.create_service_case_for_harvard(contact_id: @contact.contact_id)

      @closed_case = Setup::Data.close_service_case_for_harvard(
        contact_id: @contact.contact_id, case_id: @case.id, resolved: false
      )

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    end

    it 're-opens an unresolved closed service case', :uuqa_1727 do
      case_detail_page.go_to_closed_case_with_id(case_id: @case.id, contact_id: @contact.contact_id)
      expect(case_detail_page.page_displayed?).to be_truthy

      case_detail_page.reopen_case

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CASE_REOPENED)

      expect(case_detail_page.page_displayed?).to be_truthy
      expect(case_detail_page.status).to eq Case::OPEN_STATUS
    end
  end
end
