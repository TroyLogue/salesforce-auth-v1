require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../cases/pages/case'
require_relative '../referrals/pages/referral'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:new_case) { Case.new(@driver) }

  context('[as org user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)

      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'user can accept referral and case is opened', :uuqa_1012 do
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)

      # Accept referral into a program
      referral.accept_action

      # Case is opened with correct status
      expect(new_case.page_displayed?).to be_truthy
      expect(new_case.status).to eq(new_case.class::OPEN_STATUS)

      # Referral has updated status
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      expect(referral.status).to eq(referral.class::ACCEPTED_STATUS)
    end
  end
end
