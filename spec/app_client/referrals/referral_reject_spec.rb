require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../referrals/pages/referral'
require_relative '../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:new_referral_dashboard) { ReferralDashboard::New.new(@driver) }

  context('[as org user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(
        contact_id: @contact.contact_id
      )

      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy

      # Select client in Princeton
      @contact = Setup::Data.select_client_in_princeton(
        contact: @contact
      )
    }

    it 'user can reject a referral from an existing client', :uuqa_1048 do
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      note = Faker::Lorem.sentence(word_count: 5)

      # Options for rejection are available
      expect(referral.reject_referral_options_displayed?).to be_truthy

      # After user rejects referral, user lands on new referrals dashboard view
      referral.reject_referral_action(note: note)
      expect(new_referral_dashboard.page_displayed?).to be_truthy

      # Referrals status is updated after rejecting
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      expect(referral.status).to eq(referral.class::REJECTED_STATUS)
    end
  end
end
