# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/dashboard_nav'
require_relative './pages/screening_dashboard'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_overview_page'

describe '[Screenings - Navigation]', :screenings, :app_client do
  let(:home_page) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:dashboard_nav) { DashboardNav.new(@driver) }
  let(:all_screenings_dashboard) { ScreeningDashboard::AllScreenings.new(@driver) }
  let(:screening_detail_dashboard) { ScreeningDashboard::ScreeningDetail.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_overview) { FacesheetOverview.new(@driver) }

  context('[As a user with Screening Role]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_dashboard
      dashboard_nav.go_to_screenings
      expect(all_screenings_dashboard.page_displayed?).to be_truthy
      expect(all_screenings_dashboard.care_coordinator_filter_text).to eq ScreeningDashboard::AllScreenings::CARE_COORDINATOR_FILTER_TEXT_DEFAULT
      expect(all_screenings_dashboard.status_filter_text).to eq ScreeningDashboard::AllScreenings::STATUS_FILTER_TEXT_DEFAULT
    end

    it 'Navigate to Facesheet Overview from Screenings', :uuqa_1753 do
      all_screenings_dashboard.select_and_click_random_client
      expect(screening_detail_dashboard.page_displayed?).to be_truthy
      client_name = screening_detail_dashboard.client_name_header
      expect(all_screenings_dashboard.selected_client_name).to eq client_name
      screening_detail_dashboard.go_to_facesheet
      expect(facesheet_header.facesheet_name).to eq client_name
      expect(facesheet_overview.page_displayed?).to be_truthy
    end
  end

  context('[As a user without Screening Role]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_WITHOUT_SCREENING_ROLE)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'Dashboard Nav should not have Screenings section', :uuqa_1754 do
      left_nav.go_to_dashboard
      expect(dashboard_nav.screenings_displayed?).to be false
    end
  end
end
