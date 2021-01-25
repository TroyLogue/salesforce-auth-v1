# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class AssessmentsTable < BasePage
  ASSESSMENT = { css: '.assessment-forms .ui-table-row-column' }
  LOADING_ASSESSMENTS = { xpath: './/p[text()="Loading Assessments..."]' }


  def open_assessment_by_name(assessment_name)
    is_not_displayed?(LOADING_ASSESSMENTS)
    click_element_from_list_by_text(ASSESSMENT, assessment_name)
  end
end
