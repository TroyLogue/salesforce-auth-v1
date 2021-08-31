require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page_ehr'
require_relative './pages/assessment'
require_relative './pages/assessments_table'
require_relative '../root/pages/notifications_ehr'

describe '[Assessments]', :ehr, :assessments do
  include LoginEhr

  let(:assessment) { Assessment.new(@driver) }
  let(:assessments_table) { AssessmentsTable.new(@driver) }
  let(:homepage) { HomePageEhr.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:notifications) { NotificationsEhr.new(@driver) }


  context('[as a cc user] in the Default view') do
    before {
      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy
    }

    it 'can edit an assessment', :uuqa_399 do
      assessment_name = "Ivy League General Form"
      new_value = Faker::Alphanumeric.alpha(number: 8)

      assessments_table.open_assessment_by_name(assessment_name)
      expect(assessment.page_displayed?(assessment_name: assessment_name)).to be_truthy

      initial_value = assessment.first_response_text
      assessment.edit_assessment(new_value)

      # verify success notification:
      notification_text = notifications.success_text
      expect(notification_text).to include(NotificationsEhr::ASSESSMENT_UPDATED)

      # verify value updated:
      updated_value = assessment.first_response_text
      expect(updated_value).not_to include(initial_value)
      expect(updated_value).to include(new_value)
    end
  end
end
