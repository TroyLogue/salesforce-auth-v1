# frozen_string_literal: true
require_relative './pages/insights'
require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'

describe '[Users - ]', :app_client, :users do
  include Login

  let(:insights_page) { Insights.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }

  it 'download report and verify Tableau iFrame', :uuqa_509 do
    log_in_as(email_address: Users::INSIGHTS_USER)
    expect(home_page.page_displayed?).to be_truthy
    expect(insights_page.Insight_nav_displayed?).to be_truthy
    insights_page.click_insight_nav

    # csv report download
    insights_page.get_current_download_count
    insights_page.select_activity_first_option
    insights_page.select_file_type_csv
    insights_page.click_download
    insights_page.get_download_count_after

    # image report
    insights_page.get_current_download_count
    insights_page.select_activity_first_option
    insights_page.select_file_type_image
    insights_page.click_download
    insights_page.get_download_count_after

    # PDF report
    insights_page.get_current_download_count
    insights_page.select_activity_first_option
    insights_page.select_file_type_pdf
    insights_page.click_download
    insights_page.get_download_count_after

    expect(insights_page.download_success?).to be_truthy
    expect(insights_page.tableau_iframe_exists?).to be_truthy
  end
end
