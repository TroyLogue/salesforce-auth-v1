# frozen_string_literal: true

require_relative 'pages/new_assistance_request_page'
require_relative 'pages/new_assistance_request_dashboard_page'
require_relative '../clients/pages/add_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../referrals/pages/create_referral'
require_relative '../referrals/pages/referral_dashboard'
require_relative '../root/pages/notifications'

describe '[Refer Assistance Request]', :app_client, :assistance_request do
  let(:add_client_page) { AddClient.new(@driver) }
  let(:additional_info_page) { CreateReferral::AdditionalInfo.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:create_referral) { CreateReferral::AddReferral.new(@driver) }
  let(:final_review_page) { CreateReferral::FinalReview.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:new_assistance_request_page) { NewAssistanceRequestPage.new(@driver) }
  let(:new_assistance_request_dashboard_page) { NewAssistanceRequestDashboardPage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:referral_sent_dashboard) { ReferralDashboard::Sent::All.new(@driver) }

  before do
    # Submit assistance request
    @assistance_request = Setup::Data.submit_assistance_request_to_columbia_org
    @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_02_USER)

    homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
    expect(homepage.page_displayed?).to be_truthy
  end

  it 'Creates a referral from new assistance request', :uuqa_1712 do
    new_assistance_request_dashboard_page.go_to_new_ar_dashboard_page
    expect(new_assistance_request_dashboard_page.new_ar_dashboard_page_displayed?).to be_truthy
    expect(new_assistance_request_dashboard_page.clients_new_ar_created?(@assistance_request.full_name)).to be_truthy

    new_assistance_request_page.go_to_new_ar_with_id(ar_id: @assistance_request.ar_id)
    new_assistance_request_page.select_refer_ar_action

    if confirm_client_page.check_page_displayed?
      confirm_client_page.click_create_new_client
      expect(add_client_page.page_displayed?).to be_truthy
      add_client_page.save_client
      expect(notifications.success_text).to include(Notifications::CLIENT_CREATED)
    end

    expect(create_referral.page_displayed?).to be_truthy
    create_referral.select_first_org
    create_referral.click_next_button
    additional_info_page.click_next_button if additional_info_page.page_displayed?
    expect(final_review_page.page_displayed?).to be_truthy
    expect(final_review_page.full_name).to eq(@assistance_request.full_name)
    summary = final_review_page.summary_info[0]
    expect(summary[:description]).to eq(@assistance_request.description)
    expect(summary[:service_type]).to eq(@assistance_request.service_type_name)

    final_review_page.click_submit_button
    expect(referral_sent_dashboard.page_displayed?).to be_truthy
    notification_text = notifications.success_text
    expect(notification_text).to include(Notifications::REFERRAL_CREATED)
    expect(referral_sent_dashboard.row_values_for_client(client: @assistance_request.full_name).split(',')[1].strip)
      .to eq(@assistance_request.full_name)
  end
end
