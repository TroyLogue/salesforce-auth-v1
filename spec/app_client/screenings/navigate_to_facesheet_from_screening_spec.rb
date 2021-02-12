# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/dashboard_nav'
require_relative './pages/screening_dashboard'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_overview_page'

describe '[Screenings - Navigation]', :screenings, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:dashboard_nav) { DashboardNav.new(@driver) }
  let(:all_screenings_dashboard) { ScreeningDashboard::AllScreenings.new(@driver) }
  let(:screening_detail_dashboard) { ScreeningDashboard::ScreeningDetail.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_overview_page) { FacesheetOverviewPage.new(@driver) }

  context('[As a user with Screening Role]') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      left_nav.go_to_dashboard
      dashboard_nav.go_to_screenings
      expect(all_screenings_dashboard.page_displayed?).to be_truthy
      expect(all_screenings_dashboard.care_coordinator_filter_text).to eq ScreeningDashboard::AllScreenings::CARE_COORDINATOR_FILTER_TEXT_DEFAULT
      expect(all_screenings_dashboard.status_filter_text).to eq ScreeningDashboard::AllScreenings::STATUS_FILTER_TEXT_DEFAULT
    }

    it 'Navigate to Facesheet Overview from Screenings', :uuqa_1753 do
      all_screenings_dashboard.select_and_click_random_client
      expect(screening_detail_dashboard.page_displayed?).to be_truthy
      expect(all_screenings_dashboard.selected_client_name).to eq screening_detail_dashboard.client_name_header
      screening_detail_dashboard.go_to_facesheet
      expect(facesheet_header.facesheet_name).to eq screening_detail_dashboard.client_name_header
      expect(facesheet_overview_page.page_displayed?).to be_truthy
    end
  end

  context('[As a user without Screening Role]') do
    before {
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'Dashboard Nav should not have Screenings section', :uuqa_1754  do
      left_nav.go_to_dashboard
      expect(dashboard_nav.screenings_displayed?).to be false
    end
  end
end
