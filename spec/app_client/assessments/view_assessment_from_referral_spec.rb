require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/assessment_page'
require_relative '../../shared_components/base_page'
require_relative '../referrals/pages/dashboard_referral'

describe '[Assessments - Referrals]', :assessments, :app_client do
  include Login
  IVY_INTAKE_ASSESSMENT = "Ivy League Intake Form"

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:assessment) { Assessment.new(@driver) }
  let(:referral) { Referral.new(@driver) }

  TEST_ID = '991c16a5-6ac2-446e-8ee5-b8e59c96b0bf'
  context('[as cc user] With a new referral') do
    before {
=begin
      # Generate pending referral for CC user:
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

      user_menu.log_out
      expect(login_email.page_displayed?).to be_truthy
=end
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'can view an assessment from an incoming referral', :uuqa_326 do
#      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      referral.go_to_new_referral_with_id(referral_id: TEST_ID)

      expect(referral.take_action_button_is_displayed?).to be_truthy

      #verify assessment name is displayed
      @assessment = IVY_INTAKE_ASSESSMENT
      expect(referral.assessment_list).to include(@assessment)

      #click on assessment
      referral.open_assessment(assessment_name: @assessment)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.header_text).to include(@assessment)
      expect(assessment.is_not_filled_out?).to be_truthy
    end
  end
end
