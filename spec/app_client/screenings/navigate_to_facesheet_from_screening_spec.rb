# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative './pages/screenings_dashboard'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_overview_page'

describe '[Screenings - Navigation]', :screenings, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:screenings_dashboard) {ScreeningsDashboard.new(@driver)}
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_overview_page) { FacesheetOverviewPage.new(@driver) }

  context('[As a user with Screening Role]') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      left_nav.go_to_dashboard
      left_nav.go_to_screenings
      expect(screenings_dashboard.page_displayed?).to be_truthy
      expect(screenings_dashboard.care_coordinator_filter_text).to eq ScreeningsDashboard::CARE_COORDINATOR_FILTER_TEXT_DEFAULT
      expect(screenings_dashboard.status_filter_text).to eq ScreeningsDashboard::STATUS_FILTER_TEXT_DEFAULT
    }

    it 'Navigate to Facesheet Overview from Screenings', :uuqa_1753 do
      screenings_dashboard.select_and_click_random_client
      expect(screenings_dashboard.selected_client_name).to eq screenings_dashboard.client_name_header
      screenings_dashboard.go_to_facesheet
      expect(facesheet_header.facesheet_name).to eq screenings_dashboard.client_name_header
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
