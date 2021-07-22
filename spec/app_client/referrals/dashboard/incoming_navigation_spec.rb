# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../root/pages/notifications'
require_relative '../../root/pages/left_nav'
require_relative '../../root/pages/dashboard_nav'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals][Dashboard]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:dashboard_nav) { DashboardNav.new(@driver) }
  let(:new_referral_dashboard) { ReferralDashboard::New.new(@driver) }
  let(:p2p_referral_dashboard) { ReferralDashboard::ProviderToProvider.new(@driver) }

  context('[a Referral Admin CC user]') do
    before do
      auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_dashboard
    end

    it 'filter new referrals by care coordinator and service type', :uuqa_2109 do
      dashboard_nav.go_to_new_referrals
      expect(new_referral_dashboard.page_displayed?).to be_truthy
      expect(new_referral_dashboard.cc_headers_displayed?).to be_truthy

      new_referral_dashboard.filter_by_random_care_coordinator
      service_type = 'Disability Benefits'
      new_referral_dashboard.filter_by_service_type_id(id: Services::BENEFITS_BENEFITS_ELIGIBILITY_SCREENING)

      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(new_referral_dashboard.no_referrals_message_displayed? ||
        (new_referral_dashboard.filtered_by_care_coordinator?(care_coordinator: care_coordinator) &&
          new_referral_dashboard.filtered_by_service_type?(type: service_type))).to be_truthy
    end

    it 'navigate to provider-to-provider dashboard', :uuqa_2097 do
      dashboard_nav.go_to_provider_to_provider_referrals
      expect(p2p_referral_dashboard.page_displayed?).to be_truthy
      expect(p2p_referral_dashboard.headers_displayed?).to be_truthy
    end
  end
end
