# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative './../pages/create_referral'
require_relative './../pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:additional_info_page) { CreateReferral::AdditionalInfo.new(@driver) }
  let(:final_review_page) { CreateReferral::FinalReview.new(@driver) }
  let(:sent_referral_dashboard) { ReferralDashboard::Sent::All.new(@driver) }

  context('[as a Referral User]') do
    before do
      @contact = Setup::Data.random_existing_harvard_client

      auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'can create a new referral and out of network case in same workflow', :uuqa_1771, :smoke do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      facesheet_header.refer_client
      expect(add_referral_page.page_displayed?).to be_truthy

      # Fill out referral info
      submitted_referral_options = add_referral_page.add_referral_selecting_first_options(
        description: Faker::Lorem.sentence(word_count: 5)
      )

      # add an OON case
      add_referral_page.add_another_referral
      submitted_oon_case_options = add_referral_page.add_oon_case_selecting_first_options(
        description: Faker::Lorem.sentence(word_count: 5)
      )
      # validate that Add Another option appears after adding an OON case
      expect(add_referral_page.can_add_another_referral?).to be_truthy

      add_referral_page.click_next_button
      additional_info_page.click_next_button if additional_info_page.page_displayed?

      expect(final_review_page.page_displayed?).to be_truthy
      expect(final_review_page.summary_info.length).to eq(2)
      expect(final_review_page.summary_info[0]).to eq(submitted_referral_options)
      expect(final_review_page.summary_info[1]).to eq(submitted_oon_case_options)

      final_review_page.click_submit_button
      expect(sent_referral_dashboard.page_displayed?).to be_truthy
    end
  end
end
