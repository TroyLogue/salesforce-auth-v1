# frozen_string_literal: true

require_relative '../root/pages/dashboard_nav'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../screenings/pages/screening_page'

describe '[Screenings]', :app_client, :screenings, :screenings_edit do
  let(:dashboard) { DashboardNav.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:screening_page) { ScreeningPage.new(@driver) }

  context('[as a user with Screening Role]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent
      @screening = Setup::Data.create_screening_for_harvard_contact(contact_id: @contact.contact_id)

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it '[from the Dashboard view] user can edit the Screening', :uuqa_1799 do
      dashboard.go_to_screening(screening_id: @screening.id)

      expect(screening_page.page_displayed?).to be_truthy

      screening_page.edit_screening
      screening_page.submit_screening
      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(screening_page.page_displayed?).to be_truthy
    end

    it '[from the Facesheet view] user can edit the Screening', :uuqa_1800 do
      facesheet_header.go_to_facesheet_screening(
        contact_id: @contact.contact_id,
        screening_id: @screening.id
      )
      expect(screening_page.page_displayed?).to be_truthy
      screening_page.edit_screening
      screening_page.submit_screening
      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(screening_page.page_displayed?).to be_truthy
    end
  end
end
