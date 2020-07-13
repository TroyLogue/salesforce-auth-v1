require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative '../referrals/pages/dashboard_referral'
require_relative '../referrals/pages/dashboard_referral_table'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:notifications){ Notifications.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:referral_table) { ReferralTable.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent(token: base_page.get_uniteus_api_token)

      # Create referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(token: base_page.get_uniteus_api_token,
                                                                      contact_id: @contact.contact_id,
                                                                      service_type_id: base_page.get_uniteus_first_service_type_id)
      user_menu.log_out
      expect(login_email.page_displayed?).to be_truthy
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy

      # Select client in Princeton
      @contact = Setup::Data.select_client_in_princeton(token: base_page.get_uniteus_api_token,
                                                        contact: @contact)
    }

    it 'user can reject a referral from an existing client', :uuqa_1048 do
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      note = Faker::Lorem.sentence(word_count: 5)

      # After user rejects referral, user lands on new referrals dashboard view
      referral.reject_referral_action(note: note)
      expect(referral_table.page_displayed?).to be_truthy

      # Referrals status is updated after rejecting
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      expect(referral.status).to eq(referral.class::REJECTED_STATUS)
    end
  end
end
