# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../cases/pages/open_cases_dashboard'
require_relative '../root/pages/notifications'

describe '[cases]', :app_client, :cases do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as non cc user]') do
    before(:each) do
      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'filters by primary worker', :uuqa_1713 do
      open_cases_dashboard.go_to_open_cases_dashboard
      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      primary_worker = open_cases_dashboard.search_and_select_first_primary_worker('e')

      expect(notifications.notification_not_displayed?).to be_truthy
      expect(open_cases_dashboard.no_cases_message_displayed? || open_cases_dashboard.cases_match_primary_worker?(primary_worker)).to be_truthy
    end
  end
end