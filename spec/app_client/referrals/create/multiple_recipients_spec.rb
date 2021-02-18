# frozen_string_literal: true

require_relative '../../auth/helpers/login'
require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative './../pages/create_referral'
require_relative './../pages/referral_dashboard.rb'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:additional_info_page) { CreateReferral::AdditionalInfo.new(@driver) }
  let(:final_review_page) { CreateReferral::FinalReview.new(@driver) }
  let(:sent_referral_dashboard) { ReferralDashboard::Sent::All.new(@driver) }

  context('[as a Referral User]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent
      log_in_as(Login::CC_HARVARD)
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'send new auto-recallable referral to multiple recipients', :uuqa_1702 do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      facesheet_header.refer_client
      expect(add_referral_page.page_displayed?).to be_truthy

      # Fill out referral info for multiple recipients(2)
      submitted_referral_options = add_referral_page.create_referral_selecting_first_options(
        description: Faker::Lorem.sentence(word_count: 5),
        count: 2
      )
      add_referral_page.click_auto_recall_checkbox
      add_referral_page.click_next_button

      # Adding if condition since page is optional
      additional_info_page.click_next_button if additional_info_page.page_displayed?

      expect(final_review_page.page_displayed?).to be_truthy
      expect(final_review_page.referral_summary_info).to eq(submitted_referral_options)

      final_review_page.click_submit_button
      expect(sent_referral_dashboard.page_displayed?).to be_truthy
    end
  end
end
