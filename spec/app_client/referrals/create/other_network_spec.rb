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

  context('[as a Referral User in an org with referral permissions to another network]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_columbia_client_with_consent
      @contact.add_address # So that orgs display as opposed to a CC

      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_02_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'user can create a referral and send to another network', :uuqa_1736 do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      facesheet_header.refer_client

      expect(add_referral_page.page_displayed?).to be_truthy
      recipient_network = add_referral_page.refer_to_another_network
      submitted_referral_options = add_referral_page.add_referral_selecting_first_options(
        description: Faker::Lorem.sentence(word_count: 5)
      )
      add_referral_page.click_next_button

      # Adding if condition since page is optional
      additional_info_page.click_next_button if additional_info_page.page_displayed?

      expect(final_review_page.page_displayed?).to be_truthy
      expect(final_review_page.network).to eq(recipient_network)
      expect(final_review_page.summary_info[0]).to eq(submitted_referral_options)

      final_review_page.click_submit_button
      expect(sent_referral_dashboard.page_displayed?).to be_truthy
    end
  end
end
