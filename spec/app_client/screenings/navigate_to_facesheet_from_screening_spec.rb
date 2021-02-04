# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_overview_page'
require_relative './pages/screenings_page'

describe '[Screenings]', :screenings, :app_client do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:screenings_page) {ScreeningsPage.new(@driver)}
  let(:facesheet_overview_page) {FacesheetOverviewPage.new(@driver)}
  let(:facesheet_header) {FacesheetHeader.new(@driver)}

  context('[as a CC user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      left_nav.go_to_clients
      left_nav.go_to_screenings
      expect(screenings_page.page_displayed?).to be_truthy
      expect(screenings_page.care_coordinator_filter_text).to eq ScreeningsPage::CARE_COORDINATOR_FILTER_TEXT_DEFAULT
      expect(screenings_page.status_filter_text).to eq ScreeningsPage::STATUS_FILTER_TEXT_DEFAULT
    }

    it 'Navigate to Facesheet Overview from Screenings', :uu3_51311 do
      screenings_page.select_and_click_random_client
      expect(screenings_page.client_name).to eq screenings_page.screening_name
      screenings_page.go_to_facesheet
      expect(facesheet_header.facesheet_name).to eq screenings_page.screening_name
      expect(facesheet_overview_page.page_displayed?).to be_truthy
    end
  end
end
