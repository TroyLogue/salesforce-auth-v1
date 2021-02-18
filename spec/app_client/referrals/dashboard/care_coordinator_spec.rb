# frozen_string_literal: true

require_relative '../../auth/helpers/login'
require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:new_referral_dashboard) { ReferralDashboard::New.new(@driver) }

  context('[as a cc user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'assign a care coordinator on an incoming referral', :uuqa_1737 do
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      care_coordinator = referral.assign_first_care_coordinator
      expect(referral.current_care_coordinator).to eq(care_coordinator)
    end
  end

  context('[as a user in an cc with greater than 50 users]') do
    it 'filter by a care coordinator', :uuqa_1737 do
      log_in_as(Login::ORG_200_USERS)
      expect(homepage.page_displayed?).to be_truthy

      new_referral_dashboard.go_to_new_referrals_dashboard
      new_referral_dashboard.filter_by_care_coordinator(coordinator: 'Ab')
      expect(new_referral_dashboard.is_empty_table_displayed? || new_referral_dashboard.is_displayed?).to be_truthy
    end
  end
end
