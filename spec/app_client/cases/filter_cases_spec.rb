# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../cases/pages/open_cases_dashboard'
require_relative '../root/pages/notifications'

describe '[cases]', :app_client, :cases do
  let(:homepage) { HomePage.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as non cc user]') do
    before(:each) do
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_YALE)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'filters by primary worker', :uuqa_1713 do
      open_cases_dashboard.go_to_open_cases_dashboard
      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      primary_worker = open_cases_dashboard.search_and_select_first_primary_worker('e')

      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(open_cases_dashboard.no_cases_message_displayed? || open_cases_dashboard.cases_match_primary_worker?(primary_worker)).to be_truthy
    end
  end

  context('[as cc user]') do
    before(:each) do
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'filters by care coordinator', :uuqa_1714 do
      open_cases_dashboard.go_to_open_cases_dashboard
      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      care_coordinator = open_cases_dashboard.search_and_select_first_care_coordinator('e')

      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(open_cases_dashboard.no_cases_message_displayed? || open_cases_dashboard.cases_match_care_coordinator?(care_coordinator)).to be_truthy
    end
  end
end
