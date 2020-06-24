require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative './pages/assessment_page'
require_relative '../../shared_components/base_page'
require_relative '../../support/setup/data/contacts'
require_relative '../../support/setup/data/referrals'
require_relative '../referrals/pages/dashboard_referral'

describe '[Assessments - Referrals]', :assessments, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:assessment) { Assessment.new(@driver) }
  let(:new_referral) { Referral.new(@driver) }

  context('[as cc user] With a new referral') do
    before {
      #generate pending referral for cc user:
      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent(token: base_page.get_uniteus_api_token)

      # Create Referral
      # fill out assessment?
      @referral = Setup::Data.send_referral_from_yale_to_harvard(
        token: base_page.get_uniteus_api_token,
        contact_id: @contact.contact_id,
        service_type_id: base_page.get_uniteus_first_service_type_id
      )

      #log out of org user and in as CC user
      user_menu.log_out
      expect(login_email.page_displayed?).to be_truthy
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'can view an assessment from an incoming referral', :uuqa_326 do
      new_referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)

      #verify assessment name is displayed

      #click on assessment

      #verify assessment responses are shown
      #verify 'edit' button is displayed on assessment

    end
  end
end
