# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:new_referral_dashboard) { ReferralDashboard::New.new(@driver) }

  context('[as a cc user]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'assign a care coordinator on an incoming referral', :uuqa_1737 do
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      care_coordinator = referral.assign_random_care_coordinator
      expect(referral.current_care_coordinator).to eq(care_coordinator)
    end
  end

  context('[as a user in an cc with greater than 50 users]') do
    it 'filter by a care coordinator', :uuqa_1737 do
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_200_USERS)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      new_referral_dashboard.go_to_new_referrals_dashboard
      new_referral_dashboard.filter_by_care_coordinator(coordinator: 'Ab')
      expect(new_referral_dashboard.is_empty_table_displayed? || new_referral_dashboard.page_displayed?).to be_truthy
    end
  end
end
