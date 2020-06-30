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

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:assessment) { Assessment.new(@driver) }
  let(:referral) { Referral.new(@driver) }

  # assessment data
  IVY_INTAKE_ASSESSMENT = "Ivy League Intake Form"
  QUESTION_ONE_TEXT = Faker::Lorem.sentence(word_count: 5)
  QUESTION_TWO_TEXT = Faker::Lorem.sentence(word_count: 5)
  ASSESSMENT_FORM_VALUES = [QUESTION_ONE_TEXT, QUESTION_TWO_TEXT]

  # military assessment
  MILITARY_INFORMATION = "Military Information"

  context('[as cc user] On a new incoming referral') do
    before {
      # Generate pending referral for CC user:
      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy

      # Create Contact
      @contact = Setup::Data.create_yale_client_with_military_and_consent(token: base_page.get_uniteus_api_token)

      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(
        token: base_page.get_uniteus_api_token,
        contact_id: @contact.contact_id,
        service_type_id: base_page.get_uniteus_first_service_type_id
      )
      referral.go_to_sent_referral_with_id(referral_id: @referral.referral_id)
#      referral.go_to_sent_referral_with_id(referral_id: TEST_ID)
      expect(referral.page_displayed?).to be_truthy

      @assessment = IVY_INTAKE_ASSESSMENT
      @military_assessment = MILITARY_INFORMATION
      referral.open_assessment(assessment_name: @assessment)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.header_text).to include(@assessment)
      expect(assessment.is_not_filled_out?).to be_truthy

      assessment.edit_and_save(responses: ASSESSMENT_FORM_VALUES)
      user_menu.log_out

      expect(login_email.page_displayed?).to be_truthy
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'can view Military Information and an assessment', :uuqa_326, :uuqa_332 do
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      expect(referral.page_displayed?).to be_truthy
      expect(referral.assessment_list).to include(@assessment)
      expect(referral.assessment_list).to include(@military_assessment)

      #check military information first
      referral.open_assessment(assessment_name: @military_assessment)
      expect(assessment.military_information_page_displayed?).to be_truthy
      expect(assessment.edit_military_btn_text).to include("Edit")
      assessment.click_back_button

      #click on assessment
      referral.open_assessment(assessment_name: @assessment)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.header_text).to include(@assessment)

      # verify assessment responses were saved
      assessment_text = assessment.assessment_text
      ASSESSMENT_FORM_VALUES.each do |value|
        expect(assessment_text).to include(value.to_s)
      end
    end

# cleanup method - close referral helper doesn't exist yet
=begin
    after {
      # close referral as cc
      @close_referral = Setup::Data.close_referral_from_yale_in_harvard(
        token: base_page.get_uniteus_api_token,
        referral_id: @referral.referral_id
      )
    }
=end
  end
end
