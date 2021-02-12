# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative './pages/screenings_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_overview_page'

describe '[Screenings - Navigation]', :screenings, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:screenings_page) {ScreeningsPage.new(@driver)}
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_overview_page) { FacesheetOverviewPage.new(@driver) }

  context('[As a user with Screening Role]') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      left_nav.go_to_dashboard
      left_nav.go_to_screenings
      expect(screenings_page.page_displayed?).to be_truthy
      expect(screenings_page.care_coordinator_filter_text).to eq ScreeningsPage::CARE_COORDINATOR_FILTER_TEXT_DEFAULT
      expect(screenings_page.status_filter_text).to eq ScreeningsPage::STATUS_FILTER_TEXT_DEFAULT
    }

    it 'Navigate to Facesheet Overview from Screenings', :uuqa_1753 do
      screenings_page.select_and_click_random_client
      expect(screenings_page.selected_client_name).to eq screenings_page.screening_name
      screenings_page.go_to_facesheet
      expect(facesheet_header.facesheet_name).to eq screenings_page.screening_name
      expect(facesheet_overview_page.page_displayed?).to be_truthy
    end
  end

  context('[As a user without Screening Role]') do
    before {
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'Left Nav should not have Screenings section', :uuqa_1754  do
      left_nav.go_to_dashboard
      expect(left_nav.screenings_displayed?).to be false
    end
  end
end
