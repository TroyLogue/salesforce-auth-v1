# frozen_string_literal: true
require_relative './pages/insights'
require_relative '../auth/helpers/login'
require_relative '../root/pages/notifications'

describe '[Insights - ]', :insights do

  let(:insights) { Insights.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a insights user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::INSIGHTS_USER)
      insights.authenticate_and_navigate_to(token: @auth_token, path: '/insights')
      expect(insights.page_displayed?).to be_truthy
    end

    it 'verify insights download report', :uuqa_509 do
      insights.click_first_download_link
      expect(notifications.error_notification_not_displayed?).to be_truthy
    end

    it 'verify insights save report as CSV', :uuqa_501 do
      download_count_before = insights.current_download_count
      insights.select_activity_first_option
      insights.select_file_type_csv
      insights.click_download
      expect(insights.current_download_count).to be > download_count_before
      insights.first_file_contains(".csv")
    end

    it 'verify insights save report as png', :uuqa_503 do
      download_count_before = insights.current_download_count
      insights.select_activity_first_option
      insights.select_file_type_image
      insights.click_download
      expect(insights.current_download_count).to be > download_count_before
      insights.first_file_contains(".png")
    end

    it 'verify insights save report as PDF', :uuqa_502 do
      download_count_before = insights.current_download_count
      insights.select_activity_first_option
      insights.select_file_type_pdf
      insights.click_download
      expect(insights.current_download_count).to be > download_count_before
      insights.first_file_contains(".pdf")
    end

    it 'verify Tableau iFrame is displayed', :uuqa_389 do
      expect(insights.tableau_iframe_exists?).to be_truthy
    end

  end
end
