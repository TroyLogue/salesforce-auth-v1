require_relative '../root/pages/home_page'
require_relative '../cases/pages/case'
require_relative './pages/assessment_page'

describe '[Assessments - Cases]', :assessments, :app_client do
  let(:assessment) { Assessment.new(@driver) }
  let(:case_detail_page) { Case.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }

  context('On a new case') do
    before {
      @question_one_text = Faker::Lorem.sentence(word_count: 5)
      @question_two_text = Faker::Lorem.sentence(word_count: 5)
      @assessment_form_values = [@question_one_text, @question_two_text]

      @contact = Setup::Data.create_yale_client_with_military_and_consent

      @case = Setup::Data.create_service_case_for_yale(
        contact_id: @contact.contact_id
      )
      @assessment = Setup::Data.get_case_form_name_for_yale(
        contact_id: @contact.contact_id,
        case_id: @case.id
      )

      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_01_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'can view Military Information and an assessment', :uuqa_328, :uuqa_334 do
      case_detail_page.go_to_open_case_with_id(case_id: @case.id, contact_id: @contact.contact_id)
      expect(case_detail_page.page_displayed?).to be_truthy
      case_detail_page.wait_for_intake_assessments
      # check assessments on case detail page
      expect(case_detail_page.assessment_list).to include(@assessment)
      expect(case_detail_page.military_assessment_displayed?).to be_truthy

      #check military information first
      case_detail_page.open_military_assessment
      expect(assessment.military_information_page_displayed?).to be_truthy
      assessment.click_back_button

      # Fill out assessment from case context
      case_detail_page.open_assessment(assessment_name: @assessment)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.is_not_filled_out?).to be_truthy
      assessment.edit_and_save(responses: @assessment_form_values)

      # verify assessment responses were saved
      expect(assessment.page_displayed?).to be_truthy
      assessment_text = assessment.assessment_text
      @assessment_form_values.each do |value|
        expect(assessment_text).to include(value.to_s)
      end
    end

    after {
      Setup::Data.close_service_case_for_yale(
        contact_id: @contact.contact_id,
        case_id: @case.id
      )
    }
  end
end
