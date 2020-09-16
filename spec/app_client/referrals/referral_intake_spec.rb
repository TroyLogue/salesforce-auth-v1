require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../referrals/pages/referral'
require_relative '../intakes/pages/intake'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:intake) { Intake.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent(token: base_page.get_uniteus_api_token)

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(token: base_page.get_uniteus_api_token,
                                                                      contact_id: @contact.contact_id,
                                                                      service_type_id: base_page.get_uniteus_first_service_type_id)

      user_menu.log_out
      expect(login_email.page_displayed?).to be_truthy
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'user can start an intake on a referral', :uuqa_1344 do
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)

      # Start intake referral into a program
      referral.start_intake_action
      expect(intake.page_displayed?).to be_truthy

      # Basic info is prefilled
      expect(intake.is_info_prefilled?(
        fname: @contact.fname,
        lname: @contact.lname,
        dob: @contact.dob_formatted)).to be_truthy

      # safe intake, should be redirected to referral page with the Needs Action Status
      intake.save_intake
      expect(referral.status).to eq(referral.class::NEEDS_ACTION_STATUS)
    end

    after {
      # accepting referral for clean up purposes
      @accept_referral = Setup::Data.accept_referral_from_harvard_in_princeton(token: base_page.get_uniteus_api_token,
                                                                               referral_id: @referral.referral_id)
    }
  end
end
