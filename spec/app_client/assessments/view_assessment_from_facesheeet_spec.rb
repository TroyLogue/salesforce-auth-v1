require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../facesheet/pages/facesheet_forms_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/assessment_page'
require_relative '../../shared_components/base_page'
require_relative '../../../lib/setup_contacts'

describe '[Assessments - Facesheet]', :assessments, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:facesheet_forms) { FacesheetForms.new(@driver) }
  let(:facesheet_header) { Facesheet.new(@driver) }
  let(:assessment) { Assessment.new(@driver) }

  ASSESSMENT_NO_RULES = 'UI-Tests No Rules'
  TEST_ID = '82a88b91-06ab-4be6-84f2-2089ac791056'

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy

=begin
      #creating contact
      @contact = Setup::Contact.new
      contact_response = @contact.create(
        token: base_page.get_uniteus_api_token,
        group_id: base_page.get_uniteus_group
      )
      expect(contact_response.status.to_s).to eq('201 Created')
      @contact.contact_id = JSON.parse(
        contact_response,
        object_class: OpenStruct
      ).data.id
=end
    }

    it 'can view an assessment from facesheet view', :uuqa_101 do
      #go to forms tab of facesheet
      facesheet_header.go_to_facesheet_with_contact_id(
#        id: @contact.contact_id,
        id: TEST_ID,
        tab: 'forms'
      )
#      expect(facesheet_header.get_facesheet_name).to eql(@contact.searchable_name)
      expect(facesheet_forms.page_displayed?).to be_truthy

      #find unstarted assessment
      facesheet_forms.open_assessment_by_name(ASSESSMENT_NO_RULES)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.header_text).to include(ASSESSMENT_NO_RULES)

      assessment.click_edit_button
      expect(assessment.edit_view_displayed?).to be_truthy
    end

  end
end
