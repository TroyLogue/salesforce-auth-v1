require_relative '../auth/helpers/login'
require_relative '../facesheet/pages/facesheet_forms_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/facesheet_assessment_page'

describe '[Assessments - Facesheet]', :assessments, :app_client do
  include Login

  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:facesheet_forms) { FacesheetForms.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:assessment) { FacesheetAssessment.new(@driver) }

  ASSESSMENT_NO_RULES = 'UI-Tests No Rules'

  #assessment data
  SINGLE_LINE_TEXT = Faker::Lorem.sentence(word_count: 5)
  MULTI_LINE_TEXT = Faker::Lorem.paragraph(sentence_count: 5)
  EMAIL_ADDRESS = Faker::Internet.email
  RANDOM_NUMBER = rand(1..100)
  ONE_MONTH_AGO = Date.today.prev_month
  # date one month ago in MM/DD/YYYY format:
  DATE = ONE_MONTH_AGO.strftime("%m/%d/%Y")
  # strip leading zeroes from date to check display
  DISPLAY_DATE = ONE_MONTH_AGO.strftime("%-m/%-d/%Y")

  context('[as org user] With a new contact') do
    before {
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy

      #creating contact
      token = base_page.get_uniteus_api_token
      @contact = Setup::Data.create_princeton_client(token: token)
    }

    it 'can view and edit an assessment from facesheet view', :uuqa_101 do
      #go to forms tab of facesheet
      facesheet_header.go_to_facesheet_with_contact_id(
        id: @contact.contact_id,
        tab: 'forms'
      )
      expect(facesheet_header.get_facesheet_name).to eql(@contact.searchable_name)
      expect(facesheet_forms.page_displayed?).to be_truthy

      #find unstarted assessment
      facesheet_forms.open_assessment_by_name(ASSESSMENT_NO_RULES)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.header_text).to include(ASSESSMENT_NO_RULES)

      # confirm assessment questions are displayed and not filled out:
      expect(assessment.is_not_filled_out?).to be_truthy

      assessment.click_edit_button
      expect(assessment.edit_view_displayed?).to be_truthy

      # fill out assessment
      assessment.fill_out_form(single_line_text: SINGLE_LINE_TEXT, multi_line_text: MULTI_LINE_TEXT, email: EMAIL_ADDRESS, number: RANDOM_NUMBER, date: DATE)
      assessment.save

      #verify edit view is closed
      expect(assessment.page_displayed?).to be_truthy

      # verify information on assessment
      ASSESSMENT_FORM_VALUES = [SINGLE_LINE_TEXT, MULTI_LINE_TEXT, EMAIL_ADDRESS, RANDOM_NUMBER, DISPLAY_DATE]

      assessment_text = assessment.assessment_text
      ASSESSMENT_FORM_VALUES.each do |value|
        expect(assessment_text).to include(value.to_s)
      end
    end
  end
end
