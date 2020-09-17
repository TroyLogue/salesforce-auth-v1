require_relative '../../../shared_components/base_page'

class FacesheetForms < BasePage
  MAIN_FORM_CONTAINER = { css: '.facesheet-assessments' }.freeze
  INTAKES_TABLE = { css: '.intakes' }.freeze
  ASSESSMENTS_TABLE = { css: '.assessments-table' }.freeze
  ASSESSMENT_NAME = { xpath: '//td[text()="%s"]' }.freeze
  CREATE_NEW_INTAKE_BTN = { css: '#create-new-intake-btn' }.freeze
  FACESHEET_ASSESSMENTS = { css: '.facesheet-assessments' }.freeze

  def page_displayed?
    wait_for_spinner
    is_displayed?(MAIN_FORM_CONTAINER) &&
      is_displayed?(INTAKES_TABLE) &&
      is_displayed?(ASSESSMENTS_TABLE)
  end

  def open_assessment_by_name(name)
    click(ASSESSMENT_NAME.transform_values { |v| v % name })
  end

  def create_new_intake
    click(CREATE_NEW_INTAKE_BTN)
  end

  def assessments_displayed?
    is_displayed?(FACESHEET_ASSESSMENTS)
  end
end
