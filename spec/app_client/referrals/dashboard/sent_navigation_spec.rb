# frozen_string_literal: true

require_relative '../../root/pages/notifications'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals][Dashboard]', :app_client, :referrals do
  let(:notifications) { Notifications.new(@driver) }
  let(:sent_all_referral_dashboard) { ReferralDashboard::Sent::All.new(@driver) }

  context('[a Referral Admin User]') do
    before do
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_YALE)
      sent_all_referral_dashboard.authenticate_and_navigate_to(token: auth_token, path: '/dashboard/referrals/sent/all')
      expect(sent_all_referral_dashboard.page_displayed?).to be_truthy
      expect(sent_all_referral_dashboard.headers_displayed?).to be_truthy
    end

    it 'filter sent referrals by status', :uuqa_2082 do
      status = sent_all_referral_dashboard.filter_by_random_status
      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(sent_all_referral_dashboard.no_referrals_message_displayed? ||
        sent_all_referral_dashboard.filtered_by_status?(status: status)).to be_truthy
    end

    it 'filter sent referrals by sender', :uuqa_2083 do
      sender = sent_all_referral_dashboard.filter_by_random_sender
      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(sent_all_referral_dashboard.no_referrals_message_displayed? ||
        sent_all_referral_dashboard.filtered_by_sent_by?(sent_by: sender)).to be_truthy
    end
  end
end
