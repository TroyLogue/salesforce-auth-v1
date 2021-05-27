# frozen_string_literal: true

require_relative '../root/pages/left_nav'
require_relative '../root/pages/home_page'
require_relative './pages/nav_reports_menu_page'

describe '[Reports Navigation CC]', :navigation, :reports, :uuqa_340 do
  let(:left_nav) { LeftNav.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:nav_reports_menu_page) { NavReportsMenuPage.new(@driver) }

  context('[As a cc user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_reports
      nav_reports_menu_page.go_to_first_network
    end

    it 'Navigate populations report' do
      nav_reports_menu_page.go_to_populations_report
      expect(nav_reports_menu_page.populations_report_displayed?).to be_truthy
    end

    it 'Navigate services report' do
      nav_reports_menu_page.go_to_services_report
      # Race conditions on this report, which intermittently fails the test UU3-48225
      expect(nav_reports_menu_page.services_report_displayed?).to be_truthy
    end

    it 'Navigate network performance report' do
      nav_reports_menu_page.go_to_network_performance_report
      expect(nav_reports_menu_page.network_performance_report_displayed?).to be_truthy
    end

    it 'Navigate military report' do
      nav_reports_menu_page.go_to_military_report
      # Military report takes long to load on staging, which intermittently fails the test UU3-48225
      nav_reports_menu_page.wait_for_military_report
      expect(nav_reports_menu_page.military_report_displayed?).to be_truthy
    end
  end
end
