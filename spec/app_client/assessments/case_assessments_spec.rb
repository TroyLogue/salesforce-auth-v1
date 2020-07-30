require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/assessment_page'
require_relative '../../shared_components/base_page'
require_relative '../cases/pages/dashboard_case'

describe '[Assessments - Cases]', :assessments, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:assessment) { Assessment.new(@driver) }
  let(:case_page) { Case.new(@driver) }

  # assessment data
  IVY_INTAKE_ASSESSMENT = "Ivy League Intake Form"
  QUESTION_ONE_TEXT = Faker::Lorem.sentence(word_count: 5)
  QUESTION_TWO_TEXT = Faker::Lorem.sentence(word_count: 5)
  ASSESSMENT_FORM_VALUES = [QUESTION_ONE_TEXT, QUESTION_TWO_TEXT]

  # military assessment
  MILITARY_INFORMATION = "Military Information"

  context('[as org user] On a new incoming referral') do
    before {
      # Generate pending referral for org user:
      # log in as other user

      # Create Contact
      @contact = Setup::Data.create_yale_client_with_military_and_consent(token: base_page.get_uniteus_api_token)

      # Create Case
      # must update this method to create case!
      @case = Setup::Data.send_referral_from_yale_to_harvard(
        token: base_page.get_uniteus_api_token,
        contact_id: @contact.contact_id,
        service_type_id: base_page.get_uniteus_first_service_type_id
      )
      case_page.go_to_case_with_id(case_id: @case.case_id)
      expect(case_page.page_displayed?).to be_truthy

      @assessment = IVY_INTAKE_ASSESSMENT
      @military_assessment = MILITARY_INFORMATION

      # Fill out assessment from referral context
      case_page.open_assessment(assessment_name: @assessment)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.is_not_filled_out?).to be_truthy
      assessment.edit_and_save(responses: ASSESSMENT_FORM_VALUES)
      user_menu.log_out

      # Log in as org user to view case
      expect(login_email.page_displayed?).to be_truthy
      #log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'can view Military Information and an assessment', :uuqa_328, :uuqa_334 do
      case_page.go_to_new_referral_with_id(case_id: @case.referral_id)
      expect(case_page.page_displayed?).to be_truthy
      expect(case_page.assessment_list).to include(@assessment)
      expect(case_page.assessment_list).to include(@military_assessment)

      #check military information first
      case_page.open_assessment(assessment_name: @military_assessment)
      expect(assessment.military_information_page_displayed?).to be_truthy
      assessment.click_back_button

      #click on assessment
      case_page.open_assessment(assessment_name: @assessment)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.header_text).to include(@assessment)

      # verify assessment responses were saved
      assessment_text = assessment.assessment_text
      ASSESSMENT_FORM_VALUES.each do |value|
        expect(assessment_text).to include(value.to_s)
      end
    end

    after {
      #clean up Case data
    }
  end
end
