# frozen_string_literal: true

require_relative './pages/insights'
require_relative '../root/pages/notifications'

describe '[Insights - ]', :insights, :app_client do
  let(:insights) { Insights.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a insights user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::INSIGHTS_USER)
      insights.authenticate_and_navigate_to(token: @auth_token, path: '/insights')
      expect(notifications.error_notification_not_displayed?).to be_truthy
    end

    it 'verify Tableau iFrame is displayed', :uuqa_389 do
      expect(insights.tableau_iframe_displayed?).to be_truthy
    end
  end
end
