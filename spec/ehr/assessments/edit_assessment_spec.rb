require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative './pages/assessment_page'

describe '[Assessments]', :ehr, :assessments do
  include LoginEhr

  let(:assessment_page) { AssessmentPage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }

  context('[as a cc user] in the Default view') do
    before {
      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'can edit an assessment', :uuqa_399 do
      assessment = "Ivy League General Form"
      homepage.open_assessment_by_name(assessment)

      expect(assessment_page.page_displayed?(assessment_name: assessment)).to be_truthy
    end
  end
end
