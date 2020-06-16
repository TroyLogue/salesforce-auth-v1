require_relative '../../../shared_components/base_page'

class FacesheetForms < BasePage
  MAIN_FORM_CONTAINER = { css: '.facesheet-assessments' }
  INTAKES_TABLE = { css: '.intakes' }
  ASSESSMENTS_TABLE = { css: '.assessments-table' }
  ASSESSMENT_NAME = { xpath: '//td[text()="%s"]' }

  def page_displayed?
    is_displayed?(MAIN_FORM_CONTAINER) &&
    is_displayed?(INTAKES_TABLE) &&
    is_displayed?(ASSESSMENTS_TABLE) &&
    wait_for_spinner
  end

  def open_assessment_by_name(name)
    click(ASSESSMENT_NAME.transform_values { |v| v % name })
  end

end
