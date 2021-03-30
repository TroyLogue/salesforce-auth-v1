# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/dashboard_nav'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../screenings/pages/screening_page'

describe '[Screenings]', :app_client, :screenings, :screenings_edit do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:dashboard) { DashboardNav.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:screening_page) { ScreeningPage.new(@driver) }

  context('[as a user with Screening Role]') do
    before {
      @contact = Setup::Data.create_harvard_client_with_consent
      @screening = Setup::Data.create_screening_for_harvard_contact(contact: @contact)

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it '[from the Dashboard view] user can edit the Screening', :uuqa_1799 do
      dashboard.go_to_screening(screening_id: @screening.id)

      expect(screening_page.page_displayed?).to be_truthy

      screening_page.edit_screening
      screening_page.submit_screening
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
      expect(screening_page.page_displayed?).to be_truthy
    end
  end
end
